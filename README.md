ccrc-utils
==========

Clearcase Remote Client Utilities to make your hard life easy

## ccrc-jenkins-integration
Jenkins CCRC integration script. You will have to use one node for both SCM pulling and build steps (e.g. it's not possible to pull CCRC changes on master but fetch changes and build on a node)

#### On node
1. Setup CCRC and CCRC CLI (http://www-01.ibm.com/support/docview.wss?uid=swg24021929)
2. Setup a CCRC repo in the node's remote FS root at some _repo\_dir_
3. Put update_cc.bat somewhere and edit it to set proper CCRC connection variables

#### On master
1. Install ScriptTrigger plugin (https://wiki.jenkins-ci.org/display/JENKINS/ScriptTrigger+Plugin)
2. Set your job custom workspace directory to _repo\_dir_
3. Add ScriptTrigger build trigger to your job
4. Set ScriptTrigger's script to `your\node\path\to\update_cc.bat repo_dir`
5. Set exit code to 0
6. Restrict ScriptTrigger to run only on your node
7. Add a schedule to the ScriptTrigger
8. Do __NOT__ enable concurrent build option. It can run the update while the project is building and ruin the results
 
Now your jenkins node will be periodically asked by master to run the script and check its exit code.
Script returns 0 if update was successful and changes were found. Otherwise (if error happens or no changes found) it returns non-zero error codes.

Feel free to add any improvements to the scripts.
