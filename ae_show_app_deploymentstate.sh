#!/bin/bash
##################################################################################
#
# Desc:		    Show the deployed apps for each target and type
# Copyright:	2017-2019, Thomas Fischer <mail -AT- sedi -DOT- one>
#
##################################################################################


F_COLORS(){
	cat <<EOFCOL

    Colors and types:

        ${BLUE}ansible hosted		The app is hosted on the ansible server (this server)
                                Usually 3rd party apps$ENDC

        ${MAGENTA}git hosted		The app is defined in the central git server
                                Usually your / custom apps$ENDC

        ${RED}DISABLED		Means the app is defined for this target group but
                                the deployment is disabled (therefore the app is not
                                installed on the target)$ENDC

        ${RED}DELETE-FLAG		Means the app is defined for this target group and on
                                the next deployment it will be REMOVED from the remote target!$ENDC



EOFCOL
}

F_USAGE(){
	cat <<_EOUSAGE

    Usage info:

	-h|--help|help		this output
        -batch			machine friendly output
	-env			the target environement (production/development/...)
	<targetname>		a valid target name (group_vars/xxx)
				you can define multiple target names separated by 
				space and the whole list quoted
				e.g. "dmc heavyforwarder"
				if no targetname is given ALL targets are show
	Examples:
	
	$0 -env production deploymentserver	(will show all apps for production deploymentserver group)
	$0 -env production			(will show all apps for all production groups)
	$0 -env development "deployer dmc"	(will show all apps for both deployer and dmc group in development)
_EOUSAGE

	F_COLORS
}

MF=0
# check for calling
while [ ! -z "$1" ];do
    case "$1" in
	-h|--help|help)
	F_USAGE
	exit
	;;
	-batch)
	MF=1
	shift
	;;
	-logfile)
	LOG="$2"
	shift 2
	;;
	-env)
	TARGETENV=${2}/group_vars
	shift 2
	;;
	*)
	TARGET="$1"
	shift
	;;
    esac
done

[ -z "$TARGETENV" ] && TARGETENV=group_vars

if [ $MF -ne 1 ];then
  # define fancy color output
    RED=$(tput setaf 1)
    BLUE=$(tput setaf 4)
    MAGENTA=$(tput setaf 5)
    ENDC=$(tput sgr0)

    F_COLORS
fi

# do the magic
if [ -z "$TARGET" ];then
  [ $MF -eq 0 ] && echo -e "\nNo specific target group(s) given. Will show all (give me a second..)\n"
    # walk through all var folders,
    # catch all app definition files,
    # check for enabled or disabled state
    # write the list into APPLIST variable
    APPLIST=$(for i in $(ls $TARGETENV/ |grep -v templates);do 
	       [ $MF -eq 0 ] && echo -e "\nApps configured on $i";
              for a in $(egrep -l '(bundle|git_repo)' $TARGETENV/$i/*);do
                egrep -ql "(\s+delete:\s+[tT]rue)" $a >> /dev/null
                if [ $? -eq 0 ];then
                   [ $MF -eq 0 ] && echo "$RED${a##*/} (DELETE-FLAG)$ENDC"
                   [ $MF -eq 1 ] && echo "flagged-for-removal:${a##*/}"
                else 
	                egrep -ql "(\s+install:\s+[fF]alse)" $a
	                if [ $? -eq 0 ];then
	                    [ $MF -eq 0 ] && echo "$RED${a##*/} (DISABLED)$ENDC"
                        [ $MF -eq 1 ] && echo "disabled:${a##*/}"
                    else
	                    egrep -ql 'bundle' $a 
	                    if [ $? -eq 0 ];then
                            bundlefile=$(sed -n 's/\s*bundle:\s*\(.*\)/\1/p' $a)
                            [ $MF -eq 0 ] && echo "$BLUE${a##*/} (ansible hosted)$ENDC"
                            [ $MF -eq 1 ] && echo "ansible-hosted:${a##*/}:$bundlefile"
                        else
                            egrep -ql 'git_repo' $a
                            if [ $? -eq 0 ];then
                                [ $MF -eq 0 ] && echo "$MAGENTA${a##*/} (git hosted)$ENDC"
                                [ $MF -eq 1 ] && echo "git-hosted:${a##*/}"
		                    fi
                        fi
	                fi
                fi
	      done
	     done)
else
  [ $MF -eq 0 ] && echo -e "\nOne or multiple target group(s) given."
 for dir in $TARGET; do
     [ $MF -eq 0 ] && echo "Processing $dir..."
    if [ -d "$TARGETENV/$dir" ];then
     APPLIST="$(for i in $(ls $TARGETENV/ |grep $dir);do 
              [ $MF -eq 0 ] && echo -e "\nApps configured on $i";
              for a in $(egrep -l '(bundle|git_repo)' $TARGETENV/$i/*);do
                egrep -ql "(\s+delete:\s+[tT]rue)" $a >> /dev/null
                if [ $? -eq 0 ];then
                   [ $MF -eq 0 ] && echo "$RED${a##*/} (DELETE-FLAG)$ENDC"
                   [ $MF -eq 1 ] && echo "flagged-for-removal:${a##*/}"
                else
                    egrep -ql "(\s+install:\s+[fF]alse)" $a >> /dev/null
                    if [ $? -eq 0 ];then
                        [ $MF -eq 0 ] && echo "$RED${a##*/} (DISABLED)$ENDC"
                        [ $MF -eq 1 ] && echo "disabled:${a##*/}"
                    else
                        egrep -ql 'bundle' $a >> /dev/null 
                        if [ $? -eq 0 ];then
                            bundlefile=$(sed -n 's/\s*bundle:\s*\(.*\)/\1/p' $a)
                            [ $MF -eq 0 ] && echo "$BLUE${a##*/} (ansible hosted)$ENDC"
                            [ $MF -eq 1 ] && echo "ansible-hosted:${a##*/}:$bundlefile"
                        else
                            egrep -ql 'git_repo' $a >> /dev/null
                            if [ $? -eq 0 ];then
                                [ $MF -eq 0 ] && echo "$MAGENTA${a##*/} (git hosted)$ENDC"
                                [ $MF -eq 1 ] && echo "git-hosted:${a##*/}"
                            fi
                        fi
                    fi
                 fi
              done
             done)"
    else
      [ $MF -eq 0 ] && echo -e "\n${RED}**********************************************************\n\nTarget: >$TARGETENV/$dir< does not exists!!!\n\n**********************************************************$ENDC\n"
      [ $MF -eq 1 ] && echo "ERROR: Target >$TARGETENV/$dir< does not exists!"
    fi
  done
fi

# Show the wonderful app list ;-)
echo -e "$APPLIST"

