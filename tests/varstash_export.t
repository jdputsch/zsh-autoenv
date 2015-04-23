Test varstash with exported variables in subshell.

  $ source $TESTDIR/setup.sh || return 1

Setup test environment.

  $ mkdir sub
  $ cd sub
  $ echo 'echo ENTER; autostash MYVAR=changed; autostash MYEXPORT=changed_export' > $AUTOENV_FILE_ENTER
  $ echo 'echo LEAVE; autounstash' > $AUTOENV_FILE_LEAVE

Manually create auth file

  $ test_autoenv_auth_env_files

Set environment variable.

  $ MYVAR=orig
  $ export MYEXPORT=orig_export

Activating the env stashes it and applies a new value.

  $ cd .
  ENTER
  $ echo $MYVAR
  changed
  $ echo $MYEXPORT
  changed_export

The variable is not available in a subshell, only the exported one.

  $ $SHELL -c 'echo ${MYVAR:-empty}; echo $MYEXPORT'
  empty
  changed_export

Activate autoenv in the subshell.

  $ $SHELL -c 'source $TEST_AUTOENV_PLUGIN_FILE; echo ${MYVAR}; echo $MYEXPORT'
  ENTER
  changed
  changed_export

"autounstash" should handle the exported variables.

  $ $SHELL -c 'source $TEST_AUTOENV_PLUGIN_FILE; cd ..; echo ${MYVAR:-empty}; echo $MYEXPORT'
  ENTER
  LEAVE
  empty
  orig_export
#
# Exiting the subshell should restore.
#
#   $ pwd
#   */varstash_export.t (glob)
#   $ echo $MYVAR
#   changed
#   $ echo $MYEXPORT
#   changed_export