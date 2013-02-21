#include <fcntl.h>  
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <linux/netlink.h>
#include <cutils/properties.h>
#include <utils/Log.h>

#define UEVENT_BUFFER_SIZE 2048
#define USB_STATE_SYSFS		"/sys/class/android_usb/android0/state"
#define USB_STATE_CONNECTED    0x1
#define USB_STATE_DISCONNECTED 0x2
#define LOG_TAG "USBMON"

static int get_usb_state(void)
{
	int fd_usb_state;
	int ret;
	char state[32] = {0};

	fd_usb_state = open(USB_STATE_SYSFS, O_RDONLY);
	if (fd_usb_state == -1) {
		ALOGE("open sysfs failed");
		exit(1);
	}
	memset(state, 0, sizeof(state));
	lseek(fd_usb_state, 0, SEEK_SET);

	ret = read(fd_usb_state, state, sizeof(state));
	if (ret > 0 && strncmp(state, "CONFIGURED", strlen("CONFIGURED")) == 0){
		ALOGD("get_usb_state: USB connected!");

		return USB_STATE_CONNECTED;
	}

	ALOGD("get_usb_state: USB disconnected!");
	return USB_STATE_DISCONNECTED;

}

int main()
{
	struct sockaddr_nl client;
	int skfd, rcvlen, ret;
	int fd_usb_state;
	int current_usb_state = USB_STATE_DISCONNECTED;
	int old_usb_state = USB_STATE_DISCONNECTED;
	fd_set fds;
	int buffersize = 1024;


	skfd = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_KOBJECT_UEVENT);
	if (skfd == -1) {
		ALOGE("create socket failed.");
		exit(1);
	}

	fd_usb_state = open(USB_STATE_SYSFS, O_RDONLY);
	if (fd_usb_state == -1) {
		ALOGE("open sysfs failed");
		exit(1);
	}

	memset(&client, 0, sizeof(client));
	client.nl_family = AF_NETLINK;
	client.nl_pid = getpid();
	client.nl_groups = 1; /* receive broadcast message*/
	setsockopt(skfd, SOL_SOCKET, SO_RCVBUF, &buffersize, sizeof(buffersize));
	bind(skfd, (struct sockaddr*)&client, sizeof(client));

	current_usb_state  = get_usb_state();

	while (1) {
		char buf[UEVENT_BUFFER_SIZE] = {0};
		char state[32] = {0};
		/* receive data */
		rcvlen = recv(skfd, &buf, sizeof(buf), 0);
		if (rcvlen > 0) {
			ALOGE("%s\n", buf);
			if (memcmp(buf, "change@", 7) == 0 && strstr(buf, "android_usb")) {
				old_usb_state = current_usb_state;
				current_usb_state  = get_usb_state(); /* update state */

				if (old_usb_state != current_usb_state) {
				/* state changed, need restart engpcclient */
				ALOGD("usb state changed, restart engpcclient");
				property_set("ctl.restart", "engpcclient");
				//sleep(3);
				}
			}
		}
	}

	close(skfd);
	return 0;
}
