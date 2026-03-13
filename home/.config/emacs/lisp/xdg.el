;;; xdg.el --- XDG directory setup for Emacs

;; Base directories
(defvar my/emacs-config-dir
  (file-name-as-directory user-emacs-directory)
  "Emacs configuration directory.")

(defvar my/emacs-cache-dir
  (expand-file-name "emacs/"
                    (or (getenv "XDG_CACHE_HOME")
                        "~/.cache/"))
  "Emacs cache directory.")

(defvar my/emacs-data-dir
  (expand-file-name "emacs/"
                    (or (getenv "XDG_DATA_HOME")
                        "~/.local/share/"))
  "Emacs data directory.")

(defvar my/emacs-state-dir
  (expand-file-name "emacs/"
                    (or (getenv "XDG_STATE_HOME")
                        "~/.local/state/"))
  "Emacs state directory.")

;; Ensure directories exist
(dolist (dir (list my/emacs-config-dir
                   my/emacs-cache-dir
                   my/emacs-data-dir
                   my/emacs-state-dir))
  (make-directory dir t))

;; Package installations
(setq package-user-dir
      (expand-file-name "elpa/" my/emacs-data-dir))

;; Native compilation cache
(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (expand-file-name "eln-cache/" my/emacs-cache-dir)))

;; Customization file (kept in config repo)
(setq custom-file
      (expand-file-name "custom.el" my/emacs-config-dir))
(load custom-file 'noerror)

;; Backups
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" my/emacs-state-dir))))

;; Auto-save files
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save/" my/emacs-state-dir) t)))

;; Auto-save session data (auto-save-list)
(setq auto-save-list-file-prefix
      (expand-file-name "auto-save-list/.saves-" my/emacs-state-dir))

;;; xdg.el ends here
