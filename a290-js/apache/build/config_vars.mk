exp_exec_prefix = /u/huang238/a290-js/apache
exp_bindir = /u/huang238/a290-js/apache/bin
exp_sbindir = /u/huang238/a290-js/apache/bin
exp_libdir = /u/huang238/a290-js/apache/lib
exp_libexecdir = /u/huang238/a290-js/apache/modules
exp_mandir = /u/huang238/a290-js/apache/man
exp_sysconfdir = /u/huang238/a290-js/apache/conf
exp_datadir = /u/huang238/a290-js/apache
exp_installbuilddir = /u/huang238/a290-js/apache/build
exp_errordir = /u/huang238/a290-js/apache/error
exp_iconsdir = /u/huang238/a290-js/apache/icons
exp_htdocsdir = /u/huang238/a290-js/apache/htdocs
exp_manualdir = /u/huang238/a290-js/apache/manual
exp_cgidir = /u/huang238/a290-js/apache/cgi-bin
exp_includedir = /u/huang238/a290-js/apache/include
exp_localstatedir = /u/huang238/a290-js/apache
exp_runtimedir = /u/huang238/a290-js/apache/logs
exp_logfiledir = /u/huang238/a290-js/apache/logs
exp_proxycachedir = /u/huang238/a290-js/apache/proxy
SHLTCFLAGS =
LTCFLAGS =
MKINSTALLDIRS = /u/huang238/a290-js/apache/build/mkdir.sh
INSTALL = $(LIBTOOL) --mode=install /u/huang238/a290-js/apache/build/install.sh -c
MPM_NAME = prefork
INSTALL_DSO = yes
progname = httpd
OS = unix
SHLIBPATH_VAR = LD_LIBRARY_PATH
AP_BUILD_SRCLIB_DIRS = pcre
AP_CLEAN_SRCLIB_DIRS = pcre
bindir = ${exec_prefix}/bin
sbindir = ${exec_prefix}/bin
cgidir = ${datadir}/cgi-bin
logfiledir = ${localstatedir}/logs
exec_prefix = ${prefix}
datadir = ${prefix}
localstatedir = ${prefix}
mandir = ${prefix}/man
libdir = ${exec_prefix}/lib
libexecdir = ${exec_prefix}/modules
htdocsdir = ${datadir}/htdocs
manualdir = ${datadir}/manual
includedir = ${prefix}/include
errordir = ${datadir}/error
iconsdir = ${datadir}/icons
sysconfdir = ${prefix}/conf
installbuilddir = ${datadir}/build
runtimedir = ${localstatedir}/logs
proxycachedir = ${localstatedir}/proxy
other_targets =
progname = httpd
prefix = /u/huang238/a290-js/apache
AWK = gawk
CC = gcc
CPP = gcc -E
CXX =
CPPFLAGS =
CFLAGS =
CXXFLAGS =
LTFLAGS = --silent
LDFLAGS =
LT_LDFLAGS =
SH_LDFLAGS =
LIBS =
DEFS =
INCLUDES =
NOTEST_CPPFLAGS =
NOTEST_CFLAGS =
NOTEST_CXXFLAGS =
NOTEST_LDFLAGS =
NOTEST_LIBS =
EXTRA_CPPFLAGS = -DLINUX -D_REENTRANT -D_GNU_SOURCE
EXTRA_CFLAGS = -pthread
EXTRA_CXXFLAGS =
EXTRA_LDFLAGS =
EXTRA_LIBS = -lm
EXTRA_INCLUDES = -I$(includedir) -I. -I/usr/include/apr-1
LIBTOOL = /usr/lib64/apr-1/build/libtool --silent
SHELL = /bin/sh
RSYNC = /usr/bin/rsync
SH_LIBS =
SH_LIBTOOL = $(SHELL) $(top_builddir)/shlibtool $(LTFLAGS)
MK_IMPLIB =
MKDEP = $(CC) -MM
INSTALL_PROG_FLAGS =
APR_BINDIR = /usr/bin
APR_INCLUDEDIR = /usr/include/apr-1
APR_VERSION = 1.4.8
APR_CONFIG = /usr/bin/apr-1-config
APU_BINDIR = /usr/bin
APU_INCLUDEDIR = /usr/include/apr-1
APU_VERSION = 1.5.2
APU_CONFIG = /usr/bin/apu-1-config
