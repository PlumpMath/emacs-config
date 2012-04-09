(defvar user-dir (concat (expand-file-name "~") "/")
  "User home directory.")

(defvar config-dir (concat user-dir "conf/emacs/config/")
  "Location of configuration files.")

(defvar library-dir (concat user-dir "conf/emacs/src/")
  "Location of custom libraries.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; User configurable packages, folders, options
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar packages-to-install '(smex
                              ido-ubiquitous
                              volatile-highlights
                              expand-region
                              ack-and-a-half
                              rainbow-mode
                              )
  "Packages to be installed from marmalade.")

(defvar thirdparty-dir (concat user-dir ".emacs.d/thirdparty/")
  "Third party libraries directory.")

(defvar emacs-backups-dir (concat user-dir ".emacs-backups/")
  "Directory to store backup files in.")

(defvar smex-file (concat user-dir ".emacs.d/.smex-items")
  "File to store data and history of smex m-x completions.")

(defvar saveplace-file (concat user-dir ".emacs.d/places")
  "File to store data for save-place.")

(load (concat library-dir "jt-emacs.el"))
