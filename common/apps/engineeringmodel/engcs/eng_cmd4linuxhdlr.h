
#ifndef __ENG_CMD4LINUXHDLR_H__
#define __ENG_CMD4LINUXHDLR_H__

#define SPRDENG_OK		"OK"
#define SPRDENG_ERROR	"ERROR"
#define ENG_STREND		"\r\n"
#define ENG_TESTMODE	"engtestmode"
#define ENG_BATVOL		"/sys/class/power_supply/battery/real_time_voltage"
#define ENG_STOPCHG		"/sys/class/power_supply/battery/stop_charge"
#define ENG_CURRENT		"/sys/class/power_supply/battery/real_time_current"
#define ENG_RECOVERYCMD	"/cache/recovery/command"
#define ENG_RECOVERYDIR	"/cache/recovery"
#define ENG_CHARGERTEST_FILE "/productinfo/chargertest.file"


typedef enum{
	CMD_SENDKEY = 0,
	CMD_GETICH,
	CMD_ETSRESET,
	CMD_RPOWERON,
	CMD_GETVBAT,
	CMD_STOPCHG,
	CMD_TESTMMI,
	CMD_BTTESTMODE,
	CMD_GETBTADDR,
	CMD_SETBTADDR,
	CMD_GSNR,
	CMD_GSNW,
	CMD_GETWIFIADDR,
	CMD_SETWIFIADDR,
	CMD_CGSNW,
	CMD_ETSCHECKRESET,
	CMD_SIMCHK,
	CMD_ATDIAG,
	CMD_INFACTORYMODE,
	CMD_FASTDEEPSLEEP,
	CMD_CHARGERTEST,
	CMD_END,
	CMD_SPBTTEST,
	CMD_SPWIFITEST,
	CMD_SPGPSTEST
}ENG_CMD;


struct eng_linuxcmd_str{
	int index;
	char *name;
	int (*cmd_hdlr)(char *, char *);
};

int eng_at2linux(char *buf);
int eng_linuxcmd_hdlr(int cmd, char *req, char* rsp);

#endif
