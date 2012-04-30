;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Useful defines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; See if we're on MS Windows, OSX, Linux
(defvar mswindows-p (string-match "windows" (symbol-name system-type)))
(defvar macosx-p (equal "darwin" (symbol-name system-type)))
(defvar linux-p (string-match "linux" (symbol-name system-type)))

;; Fix shell PATH on Darwin
(if macosx-p
    (push "/usr/local/bin" exec-path))

(setq debug-on-error t)

;; Find file with given name and run a callback
(defun find-file-and-run-fn (filename &optional fn)
  (let ((cur-dir ".")
        (home-dir (expand-file-name "~"))
        (root-dir "/")
        (func (if fn
                  fn
                '(lambda (fname) (message fname)))
              ))
    (while (not (or (file-exists-p (concat cur-dir "/" filename))
                    (equal home-dir (expand-file-name cur-dir))
                    (equal root-dir (expand-file-name cur-dir))))
      (setq cur-dir (concat cur-dir "/..")))
    (if (file-exists-p (concat cur-dir "/" filename))
        (funcall func (expand-file-name (concat cur-dir "/" filename)))
      (message (concat "Failed to find: " filename)))))

(defun switch-to-window-by-name (name)
  (select-window (get-buffer-window name)))

;; Add function to multiple hooks
(defun setup-multiple-hooks (hooks fn)
  (dolist (hook hooks)
    (add-hook hook fn)))

;; Get identifier at point
(defun entity-at-point ()
  (interactive)
  (let* ((beg (save-excursion (skip-chars-backward "a-z0-9A-Z_./\-" (point-at-bol))
                              (point)))
         (end (save-excursion (skip-chars-forward "a-z0-9A-Z_./\-" (point-at-eol))
                              (point))))
    (buffer-substring beg end)))

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
(load-file (concat config-dir "12-jt-smex.el"))
(load-file (concat config-dir "13-jt-save-place.el"))
(load-file (concat config-dir "14-jt-ido-mode.el"))
(load-file (concat config-dir "15-jt-imenu.el"))
(load-file (concat config-dir "16-jt-hippie-expand.el"))
(load-file (concat config-dir "17-jt-windows.el"))
;(load-file (concat config-dir "18-jt-eshell.el"))
(load-file (concat config-dir "19-jt-open-next-line.el"))
(load-file (concat config-dir "20-jt-editing.el"))
(load-file (concat config-dir "21-jt-server.el"))
(load-file (concat config-dir "22-jt-ediff.el"))
(load-file (concat config-dir "23-jt-ack.el"))
(load-file (concat config-dir "25-jt-flymake.el"))
(load-file (concat config-dir "26-jt-regex.el"))
(load-file (concat config-dir "27-jt-cc-mode.el"))
;(load-file (concat config-dir "28-jt-hideshow.el"))
;; helm + helm dependencies
(load-file (concat config-dir "32-jt-helm.el"))
(load-file (concat config-dir "24-jt-google.el"))
(load-file (concat config-dir "11-jt-navigation.el"))
;; too expensive
(load-file (concat config-dir "31-jt-auto-complete.el"))
(load-file (concat config-dir "33-jt-projectile.el"))
(load-file (concat config-dir "29-jt-python.el"))
(load-file (concat config-dir "35-jt-pylookup.el"))
(load-file (concat config-dir "34-jt-pretty-lambda.el"))
(load-file (concat config-dir "36-jt-undo-tree.el"))
(load-file (concat config-dir "38-jt-multiterm.el"))
(load-file (concat config-dir "39-jt-sysadmin.el"))
(load-file (concat config-dir "40-jt-bookmark.el"))
(load-file (concat config-dir "41-jt-winner.el"))
(load-file (concat config-dir "42-jt-comint.el"))
