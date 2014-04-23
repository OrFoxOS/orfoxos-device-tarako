#
# Copyright (C) 2011 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

add_lunch_combo sp6821a_gonk-userdebug

if [ -z "$JS_BINARY" -a -d "$PWD/device/sprd/common/tools/jsshell/" ]; then
  JSSHELL_DIR=$PWD/device/sprd/common/tools/jsshell/$(uname -s | tr "[[:upper:]]" "[[:lower:]]")-$(uname -p | tr "[[:upper:]]" "[[:lower:]]")
  if [ -d $JSSHELL_DIR ]; then
    export JS_BINARY=$JSSHELL_DIR/js
  fi
fi
