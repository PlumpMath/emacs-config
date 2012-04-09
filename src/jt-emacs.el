;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Useful defines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; See if we're on MS Windows, OSX, Linux
(defvar mswindows-p (string-match "windows" (symbol-name system-type)))
(defvar macosx-p (equal "darwin" (symbol-name system-type)))
(defvar linux-p (string-match "linux" (symbol-name system-type)))

;; Install packages
(load-file (concat library-dir "jt-package.el"))

;; Configure packages
(load-file (concat config-dir "01-jt-color-theme.el"))
(load-file (concat config-dir "02-jt-backups.el"))
(load-file (concat config-dir "03-jt-whitespace.el"))
(load-file (concat config-dir "04-jt-font-lock.el"))
(load-file (concat config-dir "05-jt-gui-options.el"))
(load-file (concat config-dir "06-jt-keybindings.el"))
(load-file (concat config-dir "07-jt-selection.el"))
(load-file (concat config-dir "08-jt-saving.el"))
(load-file (concat config-dir "09-jt-fill-behavior.el"))
(load-file (concat config-dir "10-jt-tramp-mode.el"))
(load-file (concat config-dir "11-jt-navigation.el"))
(load-file (concat config-dir "12-jt-smex.el"))
(load-file (concat config-dir "13-jt-save-place.el"))
(load-file (concat config-dir "14-jt-ido-mode.el"))
(load-file (concat config-dir "15-jt-imenu.el"))
(load-file (concat config-dir "16-jt-hippie-expand.el"))
(load-file (concat config-dir "17-jt-windows.el"))
;(load-file (concat config-dir "18-jt-eshell.el"))
(load-file (concat config-dir "19-jt-keybindings.el"))
(load-file (concat config-dir "20-jt-editing.el"))

;; TODO load in user specific config files
