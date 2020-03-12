execution=$1
path=$2
clean_execution=${execution//[^a-zA-Z0-9 ./-]/}
clean_path=${path//[^a-zA-Z0-9 ./-]/}
if [ -z "$clean_path" ] || [ -z "$clean_execution" ] ; then
  echo "Missing required arguments."
  exit 1
fi
(exec bwrap --symlink /usr/lib/jvm/java-8-openjdk/jre/bin/java /usr/bin/java --ro-bind /usr/lib/jvm /usr/lib/jvm --ro-bind /etc/java-8-openjdk/calendars.properties /etc/java-8-openjdk/calendars.properties --ro-bind /etc/java-8-openjdk/psfontj2d.properties /etc/java-8-openjdk/psfontj2d.properties --ro-bind /etc/java-8-openjdk/flavormap.properties /etc/java-8-openjdk/flavormap.properties --ro-bind /etc/java-8-openjdk/security/java.policy /etc/java-8-openjdk/security/java.policy --ro-bind /etc/ssl/certs/java/cacerts /etc/ssl/certs/java/cacerts --ro-bind /etc/java-8-openjdk/security/java.security /etc/java-8-openjdk/security/java.security --ro-bind /etc/java-8-openjdk/psfont.properties.ja /etc/java-8-openjdk/psfont.properties.ja --ro-bind /etc/java-8-openjdk/management/jmxremote.access /etc/java-8-openjdk/management/jmxremote.access --ro-bind /etc/java-8-openjdk/management/jmxremote.password /etc/java-8-openjdk/management/jmxremote.password --ro-bind /etc/java-8-openjdk/management/snmp.acl /etc/java-8-openjdk/management/snmp.acl --ro-bind /etc/java-8-openjdk/management/management.properties /etc/java-8-openjdk/management/management.properties --ro-bind /etc/java-8-openjdk/images/cursors/cursors.properties /etc/java-8-openjdk/images/cursors/cursors.properties --ro-bind /etc/java-8-openjdk/amd64/jvm.cfg /etc/java-8-openjdk/amd64/jvm.cfg --ro-bind /etc/java-8-openjdk/content-types.properties /etc/java-8-openjdk/content-types.properties --ro-bind /etc/java-8-openjdk/logging.properties /etc/java-8-openjdk/logging.properties --ro-bind /etc/java-8-openjdk/net.properties /etc/java-8-openjdk/net.properties --ro-bind /etc/java-8-openjdk/sound.properties /etc/java-8-openjdk/sound.properties --symlink /usr/lib/jvm/java-8-openjdk/bin/javac /usr/bin/javac --ro-bind /usr/bin/gcc /usr/bin/gcc --symlink /usr/bin/python3.8 /usr/bin/python --ro-bind /usr/bin/python3.8 /usr/bin/python3.8 --ro-bind /usr/bin/as /usr/bin/as --ro-bind /usr/bin/ld /usr/bin/ld --ro-bind /usr/bin/timeout /usr/bin/timeout --ro-bind /usr/lib/gcc /usr/lib/gcc --ro-bind /usr/lib/python2.7 /usr/lib/python2.7 --ro-bind /usr/lib/libpython2.7.so.1.0 /usr/lib/libpython2.7.so.1.0 --tmpfs /usr/lib/python2.7/site-packages --ro-bind /usr/lib/python3.8 /usr/lib/python3.8 --tmpfs /usr/lib/python3.8/site-packages --ro-bind /usr/include /usr/include --ro-bind /usr/lib/crt1.o /usr/lib/crt1.o --ro-bind /usr/lib/crti.o /usr/lib/crti.o --ro-bind /usr/lib/crtn.o /usr/lib/crtn.o --ro-bind /usr/lib/gcrt1.o /usr/lib/gcrt1.o --ro-bind /usr/lib/grcrt1.o /usr/lib/grcrt1.o --ro-bind /usr/lib/Mcrt1.o /usr/lib/Mcrt1.o --ro-bind /usr/lib/rcrt1.o /usr/lib/rcrt1.o --ro-bind /usr/lib/Scrt1.o /usr/lib/Scrt1.o --ro-bind /usr/lib/libgccpp.so /usr/lib/libgccpp.so --ro-bind /usr/lib/libgccpp.so.1 /usr/lib/libgccpp.so.1 --ro-bind /usr/lib/libgccpp.so.1.4.0 /usr/lib/libgccpp.so.1.4.0 --ro-bind /usr/lib/libgcc_s.so /usr/lib/libgcc_s.so --ro-bind /usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so.1 --ro-bind /usr/lib/libc.a /usr/lib/libc.a --ro-bind /usr/lib/libc_nonshared.a /usr/lib/libc_nonshared.a --ro-bind /usr/lib/ld-linux-x86-64.so.2 /usr/lib/ld-linux-x86-64.so.2 --ro-bind /usr/lib/libc-2.31.so /usr/lib/libc-2.31.so --ro-bind /usr/lib/libcanberra.so /usr/lib/libcanberra.so --ro-bind /usr/lib/libcanberra.so.0 /usr/lib/libcanberra.so.0 --ro-bind /usr/lib/libcanberra.so.0.2.5 /usr/lib/libcanberra.so.0.2.5 --ro-bind /usr/lib/libcap-ng.so /usr/lib/libcap-ng.so --ro-bind /usr/lib/libcap-ng.so.0 /usr/lib/libcap-ng.so.0 --ro-bind /usr/lib/libcap-ng.so.0.0.0 /usr/lib/libcap-ng.so.0.0.0 --ro-bind /usr/lib/libcap.so /usr/lib/libcap.so --ro-bind /usr/lib/libcap.so.2 /usr/lib/libcap.so.2 --ro-bind /usr/lib/libcap.so.2.33 /usr/lib/libcap.so.2.33 --ro-bind /usr/lib/libcares.so /usr/lib/libcares.so --ro-bind /usr/lib/libcares.so.2 /usr/lib/libcares.so.2 --ro-bind /usr/lib/libcares.so.2.3.0 /usr/lib/libcares.so.2.3.0 --ro-bind /usr/lib/libcc1.so /usr/lib/libcc1.so --ro-bind /usr/lib/libcc1.so.0 /usr/lib/libcc1.so.0 --ro-bind /usr/lib/libcc1.so.0.0.0 /usr/lib/libcc1.so.0.0.0 --ro-bind /usr/lib/libclangAnalysis.so /usr/lib/libclangAnalysis.so --ro-bind /usr/lib/libclangAnalysis.so.9 /usr/lib/libclangAnalysis.so.9 --ro-bind /usr/lib/libclangApplyReplacements.so /usr/lib/libclangApplyReplacements.so --ro-bind /usr/lib/libclangApplyReplacements.so.9 /usr/lib/libclangApplyReplacements.so.9 --ro-bind /usr/lib/libclangARCMigrate.so /usr/lib/libclangARCMigrate.so --ro-bind /usr/lib/libclangARCMigrate.so.9 /usr/lib/libclangARCMigrate.so.9 --ro-bind /usr/lib/libclangASTMatchers.so /usr/lib/libclangASTMatchers.so --ro-bind /usr/lib/libclangASTMatchers.so.9 /usr/lib/libclangASTMatchers.so.9 --ro-bind /usr/lib/libclangAST.so /usr/lib/libclangAST.so --ro-bind /usr/lib/libclangAST.so.9 /usr/lib/libclangAST.so.9 --ro-bind /usr/lib/libclangBasic.so /usr/lib/libclangBasic.so --ro-bind /usr/lib/libclangBasic.so.9 /usr/lib/libclangBasic.so.9 --ro-bind /usr/lib/libclangChangeNamespace.so /usr/lib/libclangChangeNamespace.so --ro-bind /usr/lib/libclangChangeNamespace.so.9 /usr/lib/libclangChangeNamespace.so.9 --ro-bind /usr/lib/libclangCodeGen.so /usr/lib/libclangCodeGen.so --ro-bind /usr/lib/libclangCodeGen.so.9 /usr/lib/libclangCodeGen.so.9 --ro-bind /usr/lib/libclangCrossTU.so /usr/lib/libclangCrossTU.so --ro-bind /usr/lib/libclangCrossTU.so.9 /usr/lib/libclangCrossTU.so.9 --ro-bind /usr/lib/libclangDaemon.so /usr/lib/libclangDaemon.so --ro-bind /usr/lib/libclangDaemon.so.9 /usr/lib/libclangDaemon.so.9 --ro-bind /usr/lib/libclangDaemonTweaks.so /usr/lib/libclangDaemonTweaks.so --ro-bind /usr/lib/libclangDaemonTweaks.so.9 /usr/lib/libclangDaemonTweaks.so.9 --ro-bind /usr/lib/libclangDependencyScanning.so /usr/lib/libclangDependencyScanning.so --ro-bind /usr/lib/libclangDependencyScanning.so.9 /usr/lib/libclangDependencyScanning.so.9 --ro-bind /usr/lib/libclangDirectoryWatcher.so /usr/lib/libclangDirectoryWatcher.so --ro-bind /usr/lib/libclangDirectoryWatcher.so.9 /usr/lib/libclangDirectoryWatcher.so.9 --ro-bind /usr/lib/libclangDoc.so /usr/lib/libclangDoc.so --ro-bind /usr/lib/libclangDoc.so.9 /usr/lib/libclangDoc.so.9 --ro-bind /usr/lib/libclangDriver.so /usr/lib/libclangDriver.so --ro-bind /usr/lib/libclangDriver.so.9 /usr/lib/libclangDriver.so.9 --ro-bind /usr/lib/libclangDynamicASTMatchers.so /usr/lib/libclangDynamicASTMatchers.so --ro-bind /usr/lib/libclangDynamicASTMatchers.so.9 /usr/lib/libclangDynamicASTMatchers.so.9 --ro-bind /usr/lib/libclangEdit.so /usr/lib/libclangEdit.so --ro-bind /usr/lib/libclangEdit.so.9 /usr/lib/libclangEdit.so.9 --ro-bind /usr/lib/libclangFormat.so /usr/lib/libclangFormat.so --ro-bind /usr/lib/libclangFormat.so.9 /usr/lib/libclangFormat.so.9 --ro-bind /usr/lib/libclangFrontend.so /usr/lib/libclangFrontend.so --ro-bind /usr/lib/libclangFrontend.so.9 /usr/lib/libclangFrontend.so.9 --ro-bind /usr/lib/libclangFrontendTool.so /usr/lib/libclangFrontendTool.so --ro-bind /usr/lib/libclangFrontendTool.so.9 /usr/lib/libclangFrontendTool.so.9 --ro-bind /usr/lib/libclangHandleCXX.so /usr/lib/libclangHandleCXX.so --ro-bind /usr/lib/libclangHandleCXX.so.9 /usr/lib/libclangHandleCXX.so.9 --ro-bind /usr/lib/libclangHandleLLVM.so /usr/lib/libclangHandleLLVM.so --ro-bind /usr/lib/libclangHandleLLVM.so.9 /usr/lib/libclangHandleLLVM.so.9 --ro-bind /usr/lib/libclangIncludeFixerPlugin.so /usr/lib/libclangIncludeFixerPlugin.so --ro-bind /usr/lib/libclangIncludeFixerPlugin.so.9 /usr/lib/libclangIncludeFixerPlugin.so.9 --ro-bind /usr/lib/libclangIncludeFixer.so /usr/lib/libclangIncludeFixer.so --ro-bind /usr/lib/libclangIncludeFixer.so.9 /usr/lib/libclangIncludeFixer.so.9 --ro-bind /usr/lib/libclangIndex.so /usr/lib/libclangIndex.so --ro-bind /usr/lib/libclangIndex.so.9 /usr/lib/libclangIndex.so.9 --ro-bind /usr/lib/libclangLex.so /usr/lib/libclangLex.so --ro-bind /usr/lib/libclangLex.so.9 /usr/lib/libclangLex.so.9 --ro-bind /usr/lib/libclangMove.so /usr/lib/libclangMove.so --ro-bind /usr/lib/libclangMove.so.9 /usr/lib/libclangMove.so.9 --ro-bind /usr/lib/libclangParse.so /usr/lib/libclangParse.so --ro-bind /usr/lib/libclangParse.so.9 /usr/lib/libclangParse.so.9 --ro-bind /usr/lib/libclangQuery.so /usr/lib/libclangQuery.so --ro-bind /usr/lib/libclangQuery.so.9 /usr/lib/libclangQuery.so.9 --ro-bind /usr/lib/libclangReorderFields.so /usr/lib/libclangReorderFields.so --ro-bind /usr/lib/libclangReorderFields.so.9 /usr/lib/libclangReorderFields.so.9 --ro-bind /usr/lib/libclangRewriteFrontend.so /usr/lib/libclangRewriteFrontend.so --ro-bind /usr/lib/libclangRewriteFrontend.so.9 /usr/lib/libclangRewriteFrontend.so.9 --ro-bind /usr/lib/libclangRewrite.so /usr/lib/libclangRewrite.so --ro-bind /usr/lib/libclangRewrite.so.9 /usr/lib/libclangRewrite.so.9 --ro-bind /usr/lib/libclangSema.so /usr/lib/libclangSema.so --ro-bind /usr/lib/libclangSema.so.9 /usr/lib/libclangSema.so.9 --ro-bind /usr/lib/libclangSerialization.so /usr/lib/libclangSerialization.so --ro-bind /usr/lib/libclangSerialization.so.9 /usr/lib/libclangSerialization.so.9 --ro-bind /usr/lib/libclang.so /usr/lib/libclang.so --ro-bind /usr/lib/libclang.so.9 /usr/lib/libclang.so.9 --ro-bind /usr/lib/libclangStaticAnalyzerCheckers.so /usr/lib/libclangStaticAnalyzerCheckers.so --ro-bind /usr/lib/libclangStaticAnalyzerCheckers.so.9 /usr/lib/libclangStaticAnalyzerCheckers.so.9 --ro-bind /usr/lib/libclangStaticAnalyzerCore.so /usr/lib/libclangStaticAnalyzerCore.so --ro-bind /usr/lib/libclangStaticAnalyzerCore.so.9 /usr/lib/libclangStaticAnalyzerCore.so.9 --ro-bind /usr/lib/libclangStaticAnalyzerFrontend.so /usr/lib/libclangStaticAnalyzerFrontend.so --ro-bind /usr/lib/libclangStaticAnalyzerFrontend.so.9 /usr/lib/libclangStaticAnalyzerFrontend.so.9 --ro-bind /usr/lib/libclangTidyAbseilModule.so /usr/lib/libclangTidyAbseilModule.so --ro-bind /usr/lib/libclangTidyAbseilModule.so.9 /usr/lib/libclangTidyAbseilModule.so.9 --ro-bind /usr/lib/libclangTidyAndroidModule.so /usr/lib/libclangTidyAndroidModule.so --ro-bind /usr/lib/libclangTidyAndroidModule.so.9 /usr/lib/libclangTidyAndroidModule.so.9 --ro-bind /usr/lib/libclangTidyBoostModule.so /usr/lib/libclangTidyBoostModule.so --ro-bind /usr/lib/libclangTidyBoostModule.so.9 /usr/lib/libclangTidyBoostModule.so.9 --ro-bind /usr/lib/libclangTidyBugproneModule.so /usr/lib/libclangTidyBugproneModule.so --ro-bind /usr/lib/libclangTidyBugproneModule.so.9 /usr/lib/libclangTidyBugproneModule.so.9 --ro-bind /usr/lib/libclangTidyCERTModule.so /usr/lib/libclangTidyCERTModule.so --ro-bind /usr/lib/libclangTidyCERTModule.so.9 /usr/lib/libclangTidyCERTModule.so.9 --ro-bind /usr/lib/libclangTidyCppCoreGuidelinesModule.so /usr/lib/libclangTidyCppCoreGuidelinesModule.so --ro-bind /usr/lib/libclangTidyCppCoreGuidelinesModule.so.9 /usr/lib/libclangTidyCppCoreGuidelinesModule.so.9 --ro-bind /usr/lib/libclangTidyFuchsiaModule.so /usr/lib/libclangTidyFuchsiaModule.so --ro-bind /usr/lib/libclangTidyFuchsiaModule.so.9 /usr/lib/libclangTidyFuchsiaModule.so.9 --ro-bind /usr/lib/libclangTidyGoogleModule.so /usr/lib/libclangTidyGoogleModule.so --ro-bind /usr/lib/libclangTidyGoogleModule.so.9 /usr/lib/libclangTidyGoogleModule.so.9 --ro-bind /usr/lib/libclangTidyHICPPModule.so /usr/lib/libclangTidyHICPPModule.so --ro-bind /usr/lib/libclangTidyHICPPModule.so.9 /usr/lib/libclangTidyHICPPModule.so.9 --ro-bind /usr/lib/libclangTidyLLVMModule.so /usr/lib/libclangTidyLLVMModule.so --ro-bind /usr/lib/libclangTidyLLVMModule.so.9 /usr/lib/libclangTidyLLVMModule.so.9 --ro-bind /usr/lib/libclangTidyMiscModule.so /usr/lib/libclangTidyMiscModule.so --ro-bind /usr/lib/libclangTidyMiscModule.so.9 /usr/lib/libclangTidyMiscModule.so.9 --ro-bind /usr/lib/libclangTidyModernizeModule.so /usr/lib/libclangTidyModernizeModule.so --ro-bind /usr/lib/libclangTidyModernizeModule.so.9 /usr/lib/libclangTidyModernizeModule.so.9 --ro-bind /usr/lib/libclangTidyMPIModule.so /usr/lib/libclangTidyMPIModule.so --ro-bind /usr/lib/libclangTidyMPIModule.so.9 /usr/lib/libclangTidyMPIModule.so.9 --ro-bind /usr/lib/libclangTidyObjCModule.so /usr/lib/libclangTidyObjCModule.so --ro-bind /usr/lib/libclangTidyObjCModule.so.9 /usr/lib/libclangTidyObjCModule.so.9 --ro-bind /usr/lib/libclangTidyOpenMPModule.so /usr/lib/libclangTidyOpenMPModule.so --ro-bind /usr/lib/libclangTidyOpenMPModule.so.9 /usr/lib/libclangTidyOpenMPModule.so.9 --ro-bind /usr/lib/libclangTidyPerformanceModule.so /usr/lib/libclangTidyPerformanceModule.so --ro-bind /usr/lib/libclangTidyPerformanceModule.so.9 /usr/lib/libclangTidyPerformanceModule.so.9 --ro-bind /usr/lib/libclangTidyPlugin.so /usr/lib/libclangTidyPlugin.so --ro-bind /usr/lib/libclangTidyPlugin.so.9 /usr/lib/libclangTidyPlugin.so.9 --ro-bind /usr/lib/libclangTidyPortabilityModule.so /usr/lib/libclangTidyPortabilityModule.so --ro-bind /usr/lib/libclangTidyPortabilityModule.so.9 /usr/lib/libclangTidyPortabilityModule.so.9 --ro-bind /usr/lib/libclangTidyReadabilityModule.so /usr/lib/libclangTidyReadabilityModule.so --ro-bind /usr/lib/libclangTidyReadabilityModule.so.9 /usr/lib/libclangTidyReadabilityModule.so.9 --ro-bind /usr/lib/libclangTidy.so /usr/lib/libclangTidy.so --ro-bind /usr/lib/libclangTidy.so.9 /usr/lib/libclangTidy.so.9 --ro-bind /usr/lib/libclangTidyUtils.so /usr/lib/libclangTidyUtils.so --ro-bind /usr/lib/libclangTidyUtils.so.9 /usr/lib/libclangTidyUtils.so.9 --ro-bind /usr/lib/libclangTidyZirconModule.so /usr/lib/libclangTidyZirconModule.so --ro-bind /usr/lib/libclangTidyZirconModule.so.9 /usr/lib/libclangTidyZirconModule.so.9 --ro-bind /usr/lib/libclangToolingASTDiff.so /usr/lib/libclangToolingASTDiff.so --ro-bind /usr/lib/libclangToolingASTDiff.so.9 /usr/lib/libclangToolingASTDiff.so.9 --ro-bind /usr/lib/libclangToolingCore.so /usr/lib/libclangToolingCore.so --ro-bind /usr/lib/libclangToolingCore.so.9 /usr/lib/libclangToolingCore.so.9 --ro-bind /usr/lib/libclangToolingInclusions.so /usr/lib/libclangToolingInclusions.so --ro-bind /usr/lib/libclangToolingInclusions.so.9 /usr/lib/libclangToolingInclusions.so.9 --ro-bind /usr/lib/libclangToolingRefactoring.so /usr/lib/libclangToolingRefactoring.so --ro-bind /usr/lib/libclangToolingRefactoring.so.9 /usr/lib/libclangToolingRefactoring.so.9 --ro-bind /usr/lib/libclangTooling.so /usr/lib/libclangTooling.so --ro-bind /usr/lib/libclangTooling.so.9 /usr/lib/libclangTooling.so.9 --ro-bind /usr/lib/libclangToolingSyntax.so /usr/lib/libclangToolingSyntax.so --ro-bind /usr/lib/libclangToolingSyntax.so.9 /usr/lib/libclangToolingSyntax.so.9 --ro-bind /usr/lib/libcolordcompat.so /usr/lib/libcolordcompat.so --ro-bind /usr/lib/libcolordprivate.so /usr/lib/libcolordprivate.so --ro-bind /usr/lib/libcolordprivate.so.2 /usr/lib/libcolordprivate.so.2 --ro-bind /usr/lib/libcolordprivate.so.2.0.5 /usr/lib/libcolordprivate.so.2.0.5 --ro-bind /usr/lib/libcolord.so /usr/lib/libcolord.so --ro-bind /usr/lib/libcolord.so.2 /usr/lib/libcolord.so.2 --ro-bind /usr/lib/libcolord.so.2.0.5 /usr/lib/libcolord.so.2.0.5 --ro-bind /usr/lib/libcolorhug.so /usr/lib/libcolorhug.so --ro-bind /usr/lib/libcolorhug.so.2 /usr/lib/libcolorhug.so.2 --ro-bind /usr/lib/libcolorhug.so.2.0.5 /usr/lib/libcolorhug.so.2.0.5 --ro-bind /usr/lib/libcom_err.so /usr/lib/libcom_err.so --ro-bind /usr/lib/libcom_err.so.2 /usr/lib/libcom_err.so.2 --ro-bind /usr/lib/libcom_err.so.2.1 /usr/lib/libcom_err.so.2.1 --ro-bind /usr/lib/libconfuse.so /usr/lib/libconfuse.so --ro-bind /usr/lib/libconfuse.so.2 /usr/lib/libconfuse.so.2 --ro-bind /usr/lib/libconfuse.so.2.0.0 /usr/lib/libconfuse.so.2.0.0 --ro-bind /usr/lib/libcord.so /usr/lib/libcord.so --ro-bind /usr/lib/libcord.so.1 /usr/lib/libcord.so.1 --ro-bind /usr/lib/libcord.so.1.4.0 /usr/lib/libcord.so.1.4.0 --ro-bind /usr/lib/libcrack.so /usr/lib/libcrack.so --ro-bind /usr/lib/libcrack.so.2 /usr/lib/libcrack.so.2 --ro-bind /usr/lib/libcrack.so.2.9.0 /usr/lib/libcrack.so.2.9.0 --ro-bind /usr/lib/libcroco-0.6.so /usr/lib/libcroco-0.6.so --ro-bind /usr/lib/libcroco-0.6.so.3 /usr/lib/libcroco-0.6.so.3 --ro-bind /usr/lib/libcroco-0.6.so.3.0.1 /usr/lib/libcroco-0.6.so.3.0.1 --ro-bind /usr/lib/libcrypt-2.31.so /usr/lib/libcrypt-2.31.so --ro-bind /usr/lib/libcrypto.so /usr/lib/libcrypto.so --ro-bind /usr/lib/libcrypto.so.1.1 /usr/lib/libcrypto.so.1.1 --ro-bind /usr/lib/libcryptsetup.so /usr/lib/libcryptsetup.so --ro-bind /usr/lib/libcryptsetup.so.12 /usr/lib/libcryptsetup.so.12 --ro-bind /usr/lib/libcryptsetup.so.12.6.0 /usr/lib/libcryptsetup.so.12.6.0 --ro-bind /usr/lib/libcrypt.so /usr/lib/libcrypt.so --ro-bind /usr/lib/libcrypt.so.1 /usr/lib/libcrypt.so.1 --ro-bind /usr/lib/libc.so /usr/lib/libc.so --ro-bind /usr/lib/libc.so.6 /usr/lib/libc.so.6 --ro-bind /usr/lib/libctf-nobfd.so /usr/lib/libctf-nobfd.so --ro-bind /usr/lib/libctf-nobfd.so.0 /usr/lib/libctf-nobfd.so.0 --ro-bind /usr/lib/libctf-nobfd.so.0.0.0 /usr/lib/libctf-nobfd.so.0.0.0 --ro-bind /usr/lib/libctf.so /usr/lib/libctf.so --ro-bind /usr/lib/libctf.so.0 /usr/lib/libctf.so.0 --ro-bind /usr/lib/libctf.so.0.0.0 /usr/lib/libctf.so.0.0.0 --ro-bind /usr/lib/libcupsimage.so /usr/lib/libcupsimage.so --ro-bind /usr/lib/libcupsimage.so.2 /usr/lib/libcupsimage.so.2 --ro-bind /usr/lib/libcups.so /usr/lib/libcups.so --ro-bind /usr/lib/libcups.so.2 /usr/lib/libcups.so.2 --ro-bind /usr/lib/libcurl.so /usr/lib/libcurl.so --ro-bind /usr/lib/libcurl.so.4 /usr/lib/libcurl.so.4 --ro-bind /usr/lib/libcurl.so.4.6.0 /usr/lib/libcurl.so.4.6.0 --ro-bind /usr/lib/libcurses.so /usr/lib/libcurses.so --ro-bind /usr/lib/libcursesw.so /usr/lib/libcursesw.so --ro-bind /usr/lib/jvm/java-8-openjdk/jre/bin/../lib/amd64/jli/libjli.so /usr/lib/jvm/java-8-openjdk/jre/bin/../lib/amd64/jli/libjli.so --ro-bind /usr/lib/libc.so.6 /usr/lib/libc.so.6 --ro-bind /usr/lib/libz.so.1 /usr/lib/libz.so.1 --ro-bind /usr/lib/libdl.so.2 /usr/lib/libdl.so.2 --ro-bind /usr/lib/libpthread.so.0 /usr/lib/libpthread.so.0 --ro-bind /usr/lib64/ld-linux-x86-64.so.2 /usr/lib64/ld-linux-x86-64.so.2 --ro-bind /usr/lib/jvm/java-8-openjdk/jre/lib/amd64/libawt.so /usr/lib/jvm/java-8-openjdk/jre/lib/amd64/libawt.so --ro-bind /usr/lib/jvm/java-8-openjdk/jre/lib/amd64/libjava.so /usr/lib/jvm/java-8-openjdk/jre/lib/amd64/libjava.so --ro-bind /usr/lib/libm.so.6 /usr/lib/libm.so.6 --ro-bind /usr/lib/jvm/java-8-openjdk/jre/lib/amd64/libverify.so /usr/lib/jvm/java-8-openjdk/jre/lib/amd64/libverify.so --ro-bind /usr/lib/libavcodec.so.58 /usr/lib/libavcodec.so.58 --ro-bind /usr/lib/libavformat.so.58 /usr/lib/libavformat.so.58 --ro-bind /usr/lib/libswresample.so.3 /usr/lib/libswresample.so.3 --ro-bind /usr/lib/libavutil.so.56 /usr/lib/libavutil.so.56 --ro-bind /usr/lib/libvpx.so.6 /usr/lib/libvpx.so.6 --ro-bind /usr/lib/libwebpmux.so.3 /usr/lib/libwebpmux.so.3 --ro-bind /usr/lib/libwebp.so.7 /usr/lib/libwebp.so.7 --ro-bind /usr/lib/liblzma.so.5 /usr/lib/liblzma.so.5 --ro-bind /usr/lib/libdav1d.so.3 /usr/lib/libdav1d.so.3 --ro-bind /usr/lib/libopencore-amrwb.so.0 /usr/lib/libopencore-amrwb.so.0 --ro-bind /usr/lib/libaom.so.0 /usr/lib/libaom.so.0 --ro-bind /usr/lib/libgsm.so.1 /usr/lib/libgsm.so.1 --ro-bind /usr/lib/libmp3lame.so.0 /usr/lib/libmp3lame.so.0 --ro-bind /usr/lib/libopencore-amrnb.so.0 /usr/lib/libopencore-amrnb.so.0 --ro-bind /usr/lib/libopenjp2.so.7 /usr/lib/libopenjp2.so.7 --ro-bind /usr/lib/libopus.so.0 /usr/lib/libopus.so.0 --ro-bind /usr/lib/libspeex.so.1 /usr/lib/libspeex.so.1 --ro-bind /usr/lib/libtheoraenc.so.1 /usr/lib/libtheoraenc.so.1 --ro-bind /usr/lib/libtheoradec.so.1 /usr/lib/libtheoradec.so.1 --ro-bind /usr/lib/libvorbis.so.0 /usr/lib/libvorbis.so.0 --ro-bind /usr/lib/libvorbisenc.so.2 /usr/lib/libvorbisenc.so.2 --ro-bind /usr/lib/libx264.so.159 /usr/lib/libx264.so.159 --ro-bind /usr/lib/libx265.so.179 /usr/lib/libx265.so.179 --ro-bind /usr/lib/libxvidcore.so.4 /usr/lib/libxvidcore.so.4 --ro-bind /usr/lib/libva.so.2 /usr/lib/libva.so.2 --ro-bind /usr/lib/libmfx.so.1 /usr/lib/libmfx.so.1 --ro-bind /usr/lib/libxml2.so.2 /usr/lib/libxml2.so.2 --ro-bind /usr/lib/libbz2.so.1.0 /usr/lib/libbz2.so.1.0 --ro-bind /usr/lib/libmodplug.so.1 /usr/lib/libmodplug.so.1 --ro-bind /usr/lib/libbluray.so.2 /usr/lib/libbluray.so.2 --ro-bind /usr/lib/libgmp.so.10 /usr/lib/libgmp.so.10 --ro-bind /usr/lib/libgnutls.so.30 /usr/lib/libgnutls.so.30 --ro-bind /usr/lib/libssh.so.4 /usr/lib/libssh.so.4 --ro-bind /usr/lib/libsoxr.so.0 /usr/lib/libsoxr.so.0 --ro-bind /usr/lib/libva-drm.so.2 /usr/lib/libva-drm.so.2 --ro-bind /usr/lib/libva-x11.so.2 /usr/lib/libva-x11.so.2 --ro-bind /usr/lib/libvdpau.so.1 /usr/lib/libvdpau.so.1 --ro-bind /usr/lib/libX11.so.6 /usr/lib/libX11.so.6 --ro-bind /usr/lib/libdrm.so.2 /usr/lib/libdrm.so.2 --ro-bind /usr/lib/libogg.so.0 /usr/lib/libogg.so.0 --ro-bind /usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so.6 --ro-bind /usr/lib/libmvec.so.1 /usr/lib/libmvec.so.1 --ro-bind /usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so.1 --ro-bind /usr/lib/libicuuc.so.65 /usr/lib/libicuuc.so.65 --ro-bind /usr/lib/libfontconfig.so.1 /usr/lib/libfontconfig.so.1 --ro-bind /usr/lib/libfreetype.so.6 /usr/lib/libfreetype.so.6 --ro-bind /usr/lib/libp11-kit.so.0 /usr/lib/libp11-kit.so.0 --ro-bind /usr/lib/libidn2.so.0 /usr/lib/libidn2.so.0 --ro-bind /usr/lib/libunistring.so.2 /usr/lib/libunistring.so.2 --ro-bind /usr/lib/libtasn1.so.6 /usr/lib/libtasn1.so.6 --ro-bind /usr/lib/libnettle.so.7 /usr/lib/libnettle.so.7 --ro-bind /usr/lib/libhogweed.so.5 /usr/lib/libhogweed.so.5 --ro-bind /usr/lib/libcrypto.so.1.1 /usr/lib/libcrypto.so.1.1 --ro-bind /usr/lib/libgomp.so.1 /usr/lib/libgomp.so.1 --ro-bind /usr/lib/libXext.so.6 /usr/lib/libXext.so.6 --ro-bind /usr/lib/libXfixes.so.3 /usr/lib/libXfixes.so.3 --ro-bind /usr/lib/libxcb.so.1 /usr/lib/libxcb.so.1 --ro-bind /usr/lib/libicudata.so.65 /usr/lib/libicudata.so.65 --ro-bind /usr/lib/libexpat.so.1 /usr/lib/libexpat.so.1 --ro-bind /usr/lib/libpng16.so.16 /usr/lib/libpng16.so.16 --ro-bind /usr/lib/libharfbuzz.so.0 /usr/lib/libharfbuzz.so.0 --ro-bind /usr/lib/libffi.so.6 /usr/lib/libffi.so.6 --ro-bind /usr/lib/libXau.so.6 /usr/lib/libXau.so.6 --ro-bind /usr/lib/libXdmcp.so.6 /usr/lib/libXdmcp.so.6 --ro-bind /usr/lib/libglib-2.0.so.0 /usr/lib/libglib-2.0.so.0 --ro-bind /usr/lib/libgraphite2.so.3 /usr/lib/libgraphite2.so.3 --ro-bind /usr/lib/libpcre.so.1 /usr/lib/libpcre.so.1 --ro-bind /usr/lib/jvm/java-8-openjdk/jre/lib/amd64/libnio.so /usr/lib/jvm/java-8-openjdk/jre/lib/amd64/libnio.so --ro-bind /usr/lib/jvm/java-8-openjdk/jre/lib/amd64/libnet.so /usr/lib/jvm/java-8-openjdk/jre/lib/amd64/libnet.so --ro-bind /usr/lib/libasound.so.2 /usr/lib/libasound.so.2 --ro-bind /usr/lib/librt.so.1 /usr/lib/librt.so.1 --ro-bind /usr/lib/jvm/java-8-openjdk/jre/lib/amd64/libawt_xawt.so /usr/lib/jvm/java-8-openjdk/jre/lib/amd64/libawt_xawt.so --ro-bind /usr/lib/libXrender.so.1 /usr/lib/libXrender.so.1 --ro-bind /usr/lib/libXtst.so.6 /usr/lib/libXtst.so.6 --ro-bind /usr/lib/libXi.so.6 /usr/lib/libXi.so.6 --ro-bind /usr/lib/jvm/java-8-openjdk/jre/lib/amd64/jli/libjli.so /usr/lib/jvm/java-8-openjdk/jre/lib/amd64/jli/libjli.so --ro-bind /usr/lib/jvm/java-8-openjdk/jre/lib/amd64/libgstreamer-lite.so /usr/lib/jvm/java-8-openjdk/jre/lib/amd64/libgstreamer-lite.so --ro-bind /usr/lib/jvm/java-8-openjdk/jre/lib/amd64/libglib-lite.so /usr/lib/jvm/java-8-openjdk/jre/lib/amd64/libglib-lite.so --ro-bind /usr/lib/libthread_db.so.1 /usr/lib/libthread_db.so.1 --ro-bind /usr/lib/libpangoft2-1.0.so.0 /usr/lib/libpangoft2-1.0.so.0 --ro-bind /usr/lib/libpango-1.0.so.0 /usr/lib/libpango-1.0.so.0 --ro-bind /usr/lib/libgobject-2.0.so.0 /usr/lib/libgobject-2.0.so.0 --ro-bind /usr/lib/libfribidi.so.0 /usr/lib/libfribidi.so.0 --ro-bind /usr/lib/libthai.so.0 /usr/lib/libthai.so.0 --ro-bind /usr/lib/libdatrie.so.1 /usr/lib/libdatrie.so.1 --ro-bind /usr/lib/libGL.so.1 /usr/lib/libGL.so.1 --ro-bind /usr/lib/libGLdispatch.so.0 /usr/lib/libGLdispatch.so.0 --ro-bind /usr/lib/libGLX.so.0 /usr/lib/libGLX.so.0 --ro-bind /usr/lib/jvm/java-8-openjdk/bin/../lib/amd64/jli/libjli.so /usr/lib/jvm/java-8-openjdk/bin/../lib/amd64/jli/libjli.so --ro-bind /usr/lib/libpython3.8.so.1.0 /usr/lib/libpython3.8.so.1.0 --ro-bind /usr/lib/libutil.so.1 /usr/lib/libutil.so.1 --ro-bind /usr/lib/libopcodes-2.34.so /usr/lib/libopcodes-2.34.so --ro-bind /usr/lib/libbfd-2.34.so /usr/lib/libbfd-2.34.so --ro-bind /usr/lib/libctf.so.0 /usr/lib/libctf.so.0 --ro-bind /usr/lib/libmpc.so.3 /usr/lib/libmpc.so.3 --ro-bind /usr/lib/libmpfr.so.6 /usr/lib/libmpfr.so.6 --ro-bind /usr/lib/../lib/libstdc++.so.6 /usr/lib/../lib/libstdc++.so.6 --ro-bind /usr/lib/../lib/libm.so.6 /usr/lib/../lib/libm.so.6 --ro-bind /usr/lib/../lib/libc.so.6 /usr/lib/../lib/libc.so.6 --ro-bind /usr/lib/../lib/libgcc_s.so.1 /usr/lib/../lib/libgcc_s.so.1 --ro-bind /usr/lib/libpython2.7.so.1.0 /usr/lib/libpython2.7.so.1.0 --ro-bind /usr/lib/libpanelw.so.6 /usr/lib/libpanelw.so.6 --ro-bind /usr/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6 --ro-bind /usr/lib/libgdbm_compat.so.4 /usr/lib/libgdbm_compat.so.4 --ro-bind /usr/lib/libgdbm.so.6 /usr/lib/libgdbm.so.6 --ro-bind /usr/lib/libcrypt.so.1 /usr/lib/libcrypt.so.1 --ro-bind /usr/lib/libtk8.6.so /usr/lib/libtk8.6.so --ro-bind /usr/lib/libtcl8.6.so /usr/lib/libtcl8.6.so --ro-bind /usr/lib/libXft.so.2 /usr/lib/libXft.so.2 --ro-bind /usr/lib/libXss.so.1 /usr/lib/libXss.so.1 --ro-bind /usr/lib/libnsl.so.2 /usr/lib/libnsl.so.2 --ro-bind /usr/lib/libtirpc.so.3 /usr/lib/libtirpc.so.3 --ro-bind /usr/lib/libgssapi_krb5.so.2 /usr/lib/libgssapi_krb5.so.2 --ro-bind /usr/lib/libkrb5.so.3 /usr/lib/libkrb5.so.3 --ro-bind /usr/lib/libk5crypto.so.3 /usr/lib/libk5crypto.so.3 --ro-bind /usr/lib/libcom_err.so.2 /usr/lib/libcom_err.so.2 --ro-bind /usr/lib/libkrb5support.so.0 /usr/lib/libkrb5support.so.0 --ro-bind /usr/lib/libkeyutils.so.1 /usr/lib/libkeyutils.so.1 --ro-bind /usr/lib/libresolv.so.2 /usr/lib/libresolv.so.2 --ro-bind /usr/lib64/libdb-5.3.so /usr/lib64/libdb-5.3.so --ro-bind /usr/lib64/libpython2.7.so.1.0 /usr/lib64/libpython2.7.so.1.0 --ro-bind /usr/lib64/libc.so.6 /usr/lib64/libc.so.6 --ro-bind /usr/lib64/libpthread.so.0 /usr/lib64/libpthread.so.0 --ro-bind /usr/lib64/libdl.so.2 /usr/lib64/libdl.so.2 --ro-bind /usr/lib64/libutil.so.1 /usr/lib64/libutil.so.1 --ro-bind /usr/lib64/libm.so.6 /usr/lib64/libm.so.6 --ro-bind /usr/lib/libsqlite3.so.0 /usr/lib/libsqlite3.so.0 --ro-bind /usr/lib/libreadline.so.8 /usr/lib/libreadline.so.8 --ro-bind /usr/lib/libssl.so.1.1 /usr/lib/libssl.so.1.1 --ro-bind /usr/lib/libuuid.so.1 /usr/lib/libuuid.so.1 --symlink /usr/lib /lib --symlink /usr/lib64 /lib64 --symlink /usr/bin /bin --proc /proc --tmpfs /tmp --tmpfs /var --bind $clean_path/compiled /tmp/compiled --ro-bind $clean_path /tmp/submission --chdir / --unshare-all --new-session --die-with-parent --dir /run/user/$(id -u) --setenv XDG_RUNTIME_DIR '/run/user/`id -u`' $clean_execution)
