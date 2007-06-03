# SERVICE: daemon/sendmail/prepare
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister task
		iset need = system/bootmisc
		iset once
		iexec task
	idone
}

task()
{
	if [ -x /usr/bin/make -a -f /etc/mail/Makefile ]; then
		@make@ all -C /etc/mail -s >/dev/null
	else
		for i in virtusertable access domaintable mailertable; do
			[ -f /etc/mail/$i ] &&
				@makemap@ hash /etc/mail/$i < /etc/mail/$i
		done
	fi
	@/usr/bin/newaliases@ >/dev/null 2>&1
}
