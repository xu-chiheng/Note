
# Setting up Git
When setting up remotes in git for GitHub there are a few options.
One suggested way to handle this is to set eclipse-cdt/cdt as the upstream repo and your fork's yourname/cdt as the origin repo. Remembering to generally fetch from upstream and push to origin.




# Develop with Eclipse Committers

1. Double click "remove_unneeded_plug-ins.cmd" to remove unneeded plugins.
2. Eclipse Committers, Import -> Git -> Projects from Git, select the source directory, like “E:\Note\IDE\cdt”.
3. Run "git reset --hard HEAD" to restore deleted files
4. Eclipse Committers, In Java Perspective, double click "org.eclipse.cdt.target/cdt.target", or in Plug-in Development Perspective, double click "org.eclipse.cdt.root/releng/org.eclipse.cdt.target/cdt.target"

Target Definition -> Set As Active Target Platform
Right down corner : Resolving "cdt" target definition ... 
Double click it to show progress.
Wait it to complete.

5. Eclipse Committers, In Java Perspective, select org.eclipse.cdt.ui, Run/Debug as Eclipse Application



