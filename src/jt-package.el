(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents)) ; rerun occasionally

(dolist (package packages-to-install)
  (when (not (package-installed-p package))
    (package-install package)))
