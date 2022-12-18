#------------------------------------
# Define params
#------------------------------------
OS_RELEASE_VER="$(cat /etc/os-release |grep -i pretty_name | cut -d'"' -f2 | grep -Eo "[[:print:]]+[[:digit:]\.]+")"


#------------------------------------
# Define lib path
#------------------------------------
LIB="${OS_PRE_LIB}/lib"

#------------------------------------------------------------------------------------------------------------
# do something BEFORE ALL FUNCTIONS HERE
#------------------------------------------------------------------------------------------------------------
# do something here
# --- make sure this is for ubuntu only ---
IS_UBUNTU="$(echo ${OS_RELEASE_VER} | grep -i "ubuntu")"
if [[ -z "${IS_UBUNTU}" ]]; then
  echo "Make sure run this preparation under OS \"Ubuntu\""
  exit
fi

#------------------------------------
# Include libaries
#------------------------------------
LIB_SCRIPTS="$(ls $LIB |grep -E "^L_[0-9][0-9]_[^[:space:]]+(.sh)$" | sort -n)"
for LIB_SCRIPT in $LIB_SCRIPTS
do
  . $LIB/$LIB_SCRIPT
  #echo "$LIB_SCRIPT"
done
#exit


#------------------------------------------------------------------------------------------------------------
# do something AFTER ALL FUNCTIONS HERE
#------------------------------------------------------------------------------------------------------------
# do something here

