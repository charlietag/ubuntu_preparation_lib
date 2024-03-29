L_NTP_DATETIME() {
  #-----------------------------------------------------------------------------------------
  # NTP update date time and hwclock to prevent mariadb cause systemd warning
  #-----------------------------------------------------------------------------------------
  if_chrony_found="$(dpkg -l chrony 2>/dev/null | grep "ii")"
  if_timesyncd_found="$(dpkg -l systemd-timesyncd | grep "ii")"

  # ------------------------------------
  # Chrony
  # ------------------------------------
  if [[ -n "${if_chrony_found}" ]]; then
    ntp_url="$(cat /etc/chrony/chrony.conf /etc/chrony/conf.d/*.conf 2>/dev/null |grep -E "^pool" | head -n 1 | awk '{print $2}')"
    if [[ -z "${ntp_url}" ]]; then
      ntp_url="pool.ntp.org"
    fi
    echo "---------------------------------------------------"
    echo "NTP(chrony) ---> ${ntp_url}"
    echo "---------------------------------------------------"
    # make sure chronyd stop first , before syncing time using chronyd command!
    # in ubuntu chronyd.service is an alias of chron.service
    # systemctl stop chronyd
    # systemctl disable chronyd

    if_chrony_default_enabled="$(systemctl list-unit-files |grep -E "chrony[[:print:]]+service[[:space:]]+enabled" | head -n 1)"

    systemctl stop chrony
    systemctl disable chrony

    echo "RUN: chronyd -q 'pool ${ntp_url} iburst'"

    # https://chrony.tuxfamily.org/faq.html
    # chronyd -q 'pool pool.ntp.org iburst'
    chronyd -q -t 1 "server ${ntp_url} iburst maxsamples 1"

    # echo "RUN: hwclock -w"
    # hwclock -w
    if [[ -n "${if_chrony_default_enabled}" ]]; then
      systemctl start chrony
      systemctl enable chrony
    fi

  # ------------------------------------
  # timesyncd
  # ------------------------------------
  elif [[ -n "${if_timesyncd_found}" ]]; then
    echo "---------------------------------------------------"
    echo "NTP(systemd-timesyncd) ---> $(cat /etc/systemd/timesyncd.conf |grep "^NTP" | cut -d'=' -f2- | awk '{print $1}')"
    echo "---------------------------------------------------"
    systemctl stop systemd-timesyncd
    systemctl start systemd-timesyncd

  fi

  echo "---------------------------------------------------"
  echo ""


}
