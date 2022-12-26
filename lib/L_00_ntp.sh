L_NTP_DATETIME() {
  #-----------------------------------------------------------------------------------------
  # NTP update date time and hwclock to prevent mariadb cause systemd warning
  #-----------------------------------------------------------------------------------------
  echo "---------------------------------------------------"
  echo "NTP(chrony) ---> pool.ntp.org"
  echo "---------------------------------------------------"
  dpkg -l chrony 2>/dev/null >/dev/null || apt install -y chrony
  # make sure chronyd stop first , before syncing time using chronyd command!
  # in ubuntu chronyd.service is an alias of chron.service
  # systemctl stop chronyd
  # systemctl disable chronyd

  default_chrony_status="$(systemctl list-unit-files |grep chrony | grep service|grep enabled | head -n 1)"

  systemctl stop chrony
  systemctl disable chrony

  echo "RUN: chronyd -q 'pool pool.ntp.org iburst'"

  # https://chrony.tuxfamily.org/faq.html
  # chronyd -q 'pool pool.ntp.org iburst'
  chronyd -q -t 1 'server pool.ntp.org iburst maxsamples 1'

  echo "RUN: hwclock -w"
  hwclock -w

  echo "---------------------------------------------------"
  echo ""

  if [[ -n "${default_chrony_status}" ]]; then
    systemctl start chrony
    systemctl enable chrony
  fi

}
