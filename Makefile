.POSIX:

CRYSTAL = crystal

test: .phony
	$(CRYSTAL) run test/helpers/pre_test.cr
	$(CRYSTAL) run test/*_test.cr
	$(CRYSTAL) run test/helpers/post_test.cr

.phony:
