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
  "Location of custom libraries.")

(defvar emacs-backups (concat user-home ".emacs-backups")
  "Directory to store backup files in.")

(defvar thirdparty-home (concat user-home ".emacs.d/thirdparty/")
  "Third party libraries directory.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Useful defines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; See if we're on MS Windows, OSX, Linux
(defvar mswindows-p (string-match "windows" (symbol-name system-type)))
(defvar macosx-p (equal "darwin" (symbol-name system-type)))
(defvar linux-p (string-match "linux" (symbol-name system-type)))

;; Install packages
(load-file (concat library-home "jt-package.el"))

;; Configure packages
(load-file (concat config-home "01-jt-color-theme.el"))
(load-file (concat config-home "02-jt-backups.el"))
(load-file (concat config-home "03-jt-whitespace.el"))
(load-file (concat config-home "04-jt-font-lock.el"))
(load-file (concat config-home "05-jt-gui-options.el"))
(load-file (concat config-home "06-jt-keybindings.el"))
(load-file (concat config-home "07-jt-selection.el"))
(load-file (concat config-home "08-jt-saving.el"))
(load-file (concat config-home "09-jt-fill-behavior.el"))
(load-file (concat config-home "10-jt-tramp-mode.el"))
(load-file (concat config-home "11-jt-navigation.el"))

;; TODO load in user specific config files
