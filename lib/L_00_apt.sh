L_UPDATE_REPO() {
  #-----------------------------------------------------------------------------------------
  # Before everything clean all apt cache
  #-----------------------------------------------------------------------------------------
  local first_param="$1"


  apt clean

  ############### Fetch apt repo retry Loop #############
  local apt_repo_install_retry=5000

  if [[ -n "${first_param}" ]]; then
    apt_repo_install_retry="${first_param}"
  fi

  #let apt_repo_install_retry++
  #for ((i=1; i<=apt_repo_install_retry; i++)); do
  echo "Updating apt Repo list....."

  for ((i=1; ; i++)); do

    # ---------- Check DNF Repo Installation -----------
    apt update
    local apt_repo_check=$?
    if [[ ${apt_repo_check} -eq 0 ]]; then
      echo "apt Repo is updated successfully!"
      break
    fi

    if [[ ${apt_repo_check} -ne 0 ]]; then
      echo "apt Repo is not updated yet!"
      [[ $i -gt $apt_repo_install_retry ]] && exit
    fi

    echo -n "apt Repo updating (try: $i) "
    #sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; echo ""
    sleep 1; echo -n "."; echo ""
  done

  echo ""
  ############### Fetch apt repo retry Loop #############
}

# ----------------------------------------------------------------------------------
