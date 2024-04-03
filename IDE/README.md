
# Setting up Git
When setting up remotes in git for GitHub there are a few options.
One suggested way to handle this is to set eclipse-cdt/cdt as the upstream repo and your fork's yourname/cdt as the origin repo. Remembering to generally fetch from upstream and push to origin.


# About Eclipse SDK
The JDT and PDE are plug-in tools for the Eclipse Platform. Together, these three pieces form the Eclipse SDK download, a complete development environment for Eclipse-based tools, and for developing Eclipse itself.
Eclipse SDK的源代码放到IDE目录中，并且加入到IDE_cdt和IDE_ultragdb的Source Insight Project中。


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



# Add product
1.打开Eclipse 4.4.1,New --> Plug-in Development --> Plug-in Project,创建插件com.verykit.ultragdb-product,
location 为 D:\org.eclipse.cdt\product\com.verykit.ultragdb-product .
uncheck "Create a Java project".
uncheck "Create a plug-in using one of the templates".

2.将com.verykit.ultragdb-product加入到remove-unneeded-plugins.sh.txt中.

3.运行remove-unneeded-plugins.cmd脚本,删除不相关的插件.

4.关闭并重新打开Eclipse 4.4.1,使用一个新的,空的workspace目录.

5.使用Import -> Git -> Project from Git 导入所有剩下的（相关的）插件.

6.运行git_reset_--hard_HEAD.cmd,恢复Git目录.

7.New --> Plug-in Development --> Product Configuration,
选择parent folder为com.verykit.ultragdb-product,
填写File name为4.4-win64.product,
勾选"Create a configuration file with basic settings".

8.在打开的4.4-win64.product中,点击Overview中Product Definition的New...按钮,在"New Product Definition"对话框中
输入"Product Name"为"UltraGDB",
输入"Defining Plug-in"为默认值"com.verykit.ultragdb-product",
输入"Product ID"为"44win64",
在"Product Application"的"Application"复选框中选择"org.eclipse.ui.ide.workbench".

9.在打开的4.4-win64.product中,点击Dependencies,点击Add...按钮,
将所有已经打开的org.eclipse.cdt.*插件全部加入,还需要加入com.verykit.ultragdb-product,com.verykit.common,com.verykit.license,org.eclipse.ui.ide.application 和 org.eclipse.ui.themes插件.
check"Include optional dependencies when computing required plug-ins",点击"Add Required Plug-ins",并保存.

10.在打开的4.4-win64.product中,点击Launching,在Launcher Name中输入UltraGDB,并保存.

11.在打开的4.4-win64.product中,点击Overview中的Synchronize.

12.在打开的4.4-win64.product中,分别点击Overview中的"Launch an Eclipse application"和"Launch an Eclipse application in Debug mode",应该都可以启动UltraGDB产品.

13.点击插件com.verykit.ultragdb-product的文件build.properties,在Binary Build中check plugin.xml文件.这使得plugin.xml文件包含在Export出来的UltraGDB产品中.
这一步很重要,否则Export出的UltraGDB启动时找不到plugin.xml文件,所以也找不到其中所定义的eclipse.product=com.verykit.ultragdb-product.44win64 .

14.在打开的4.4-win64.product中,点击Overview中的"Eclipse Product export wizard",弹出"Export"对话框,
"Configuration"中保持默认值"/com.verykit.ultragdb-product/4.4-win64.product",
"Root directory"中填写"UltraGDB",
"Destination",check "Directory",并选择"C:\".
点击Finish.




进一步的定制
/com.verykit.ultragdb-product/plugin_customization.ini
点击插件com.verykit.ultragdb-product的文件build.properties,在Binary Build中check plugin_customization.ini文件

参考Eclipse CPP SDK的 eclipse\plugins\org.eclipse.epp.package.cpp_2.0.2.20140224-0000\plugin_customization.ini文件,并加入如下行:
org.eclipse.ui.editors/textDragAndDropEnabled=false

org.eclipse.cdt.ui/scalability.numberOfLines=50000
org.eclipse.cdt.ui/scalability.reconciler=false


在打开的4.4-win64.product中,点击Launching,在Launching Arguments --> VM Arguments中增加-Dfile.encoding=UTF-8







Eclipse 4.3.2在导出visualgpp.product时出错.某些插件无法找到.
Eclipse 4.4.1则没有此问题.

可见,Eclipse 从 4.3.2 到 4.4.1 , 某些内部实现发生了大的变化.




Add Eclipse Product Configuration for Visual G++.

Now we can export the plugins as a eclipse product using Eclipse 4.4.1.


Eclipse 4.3.2在导出visualgpp.product时出错.某些插件无法找到.
Eclipse 4.4.1则没有此问题.

可见,Eclipse 从 4.3.2 到 4.4.1 , 某些内部实现发生了大的变化.

