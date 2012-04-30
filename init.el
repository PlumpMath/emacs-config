(defvar user-dir (concat (expand-file-name "~") "/")
  "User home directory.")

(defvar install-dir
  (file-name-directory (file-truename (or load-file-name
                                          buffer-file-name)))
  "Configuration install dir")

(defvar config-dir (concat install-dir "config/")
  "Location of configuration files.")

(defvar library-dir (concat install-dir "src/")
  "Location of custom libraries.")

(defvar thirdparty-elisp-dir (concat install-dir "thirdparty/")
  "Location of third party elisp libraries.")

(add-to-list 'load-path thirdparty-elisp-dir)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; User configurable packages, folders, options
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar packages-to-install '(smex
                              ido-ubiquitous
                              volatile-highlights
                              expand-region
                              ack-and-a-half
                              rainbow-mode
                              rainbow-delimiters
                              flymake
                              flymake-cursor
                              auto-complete
                              multi-term
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

(defvar auto-complete-dir (concat user-dir ".emacs.d/elpa/auto-complete-1.4/dict/")
  "Dir to store data for auto-complete-mode.")

(setq debug-on-error t)

(defvar jt-debug nil
  "Print debug messages for jt methods")

(defun jt-message (&rest args)
  (if jt-debug
      (apply 'message args)))

;; Install packages
(load-file (concat library-dir "jt-package.el"))

;; Configurations
(load (concat library-dir "jt-emacs.el"))
