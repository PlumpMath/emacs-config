;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; User configurable options
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar packages-to-install '()
  "Packages to be installed from marmalade.")

(defvar user-home (concat (expand-file-name "~") "/")
  "User home directory.")

;; location of Emacs-Lisp configuration files
(defvar config-home (concat user-home "conf/emacs/config/")
  "Location of configuration files.")

(defvar library-home (concat user-home "conf/emacs/src/")
  "Location of 3rd party libraries.")

(defvar emacs-backups (concat user-home ".emacs-backups")
  "Directory to store backup files in.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Useful defines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; See if we're on MS Windows, OSX, Linux
(defvar mswindows-p (string-match "windows" (symbol-name system-type)))
(defvar macosx-p (equal "darwin" (symbol-name system-type)))
(defvar linux-p (string-match "linux" (symbol-name system-type)))

;; Install packages
(load-file (concat library-home "jt-package.el"))

;; load in awesome config files
; (load-file (concat conf-home "db-emacs.el"))
; (load-file (concat conf-home "jt-emacs.el"))

