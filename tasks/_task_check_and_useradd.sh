#-----------------------------------------------------------------------------------------
# Make sure variable ${current_user} is defined
#-----------------------------------------------------------------------------------------
if [[ -z "${current_user}" ]]; then
  echo "variable \"current_user\" is not defined!"
  exit
fi

#-----------------------------------------------------------------------------------------
# add userif not exists
#-----------------------------------------------------------------------------------------
local if_current_user="$(getent passwd ${current_user})"
if [[ -z "${if_current_user}" ]]; then

  # same as:
  # adduser -q --disabled-login --gecos "" ${current_user}
  useradd -m -s /bin/bash ${current_user}
  local current_user_home="$(getent passwd "$current_user" | cut -d':' -f6)"
  chmod 755 ${current_user_home}
  #---------------------------
  # Other user manipulation
  #---------------------------
  # --- Lock user ---
  # usermod -s "/bin/false" <username>

  # --- Ubuntu adduser info save here ---
  # /etc/passwd

  # --- check users ---
  # lslogins
  # --- userdel , deluser ---
  # userdel -r <username>
  # deluser --remove-home <username>

  # -- danger --
  # find / belongs to username and delete it
  # deluser --remove-all-files <username>


  #---------------------------

fi

echo ""
