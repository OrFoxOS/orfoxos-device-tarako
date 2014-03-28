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

export MOZ_CHROME_MULTILOCALE="bn-BD en-US"
export L10NBASEDIR=$PWD/gecko-l10n
export PYTHONPATH=$PWD/gecko-l10n/compare-locales/lib
export PATH=$PATH:$PWD/gecko-l10n/compare-locales/scripts
