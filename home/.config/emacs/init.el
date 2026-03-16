;;(load (expand-file-name "lisp/xdg.el" user-emacs-directory))
;; (add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
;; (require 'xdg)

(defun reload-config ()
  (interactive)
  (load-file user-init-file))

(defun restart-emacs-service ()
  (interactive)
  (start-process-shell-command
   "restart-emacs" nil "systemctl --user restart emacs"))

;; Put backup files in one place
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; Put auto-save files in one place
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-saves/" t)))

n;; Make yes-or-no-p function use shorter y/n
(setq use-short-answers t)

;; When opening help, move pointer to window
(setq help-window-select t)

;; Swap buffer-menu for ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; start org-mode with org-indented-mode, indenting headers
(setq org-startup-indented t)

;; start org-mode with org-num-mode, numbering the headers
(setq org-startup-numerated t)

(recentf-mode 1)

;; allow fido-mode to complete buffer with C-M-i
(setq icomplete-in-buffer 1)
(fido-mode 1)
(advice-add 'completion-at-point
            :after #'minibuffer-hide-completions)

;; Core files
(setq org-default-notes-file "~/notes/org/inbox.org")

(setq org-agenda-files '("~/notes/org/inbox.org"
                          "~/notes/org/notes.org"))

(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))

;; Refile settings
(setq org-refile-use-outline-path nil)
(setq org-refile-allow-creating-parent-nodes 'confirm)

;; Auto-save after refile and capture
(advice-add 'org-refile :after 'org-save-all-org-buffers)
(add-hook 'org-capture-after-finalize-hook 'org-save-all-org-buffers)

;; Capture templates
(setq org-capture-templates
      '(("t" "Todo" entry (file "~/notes/org/inbox.org")
         "* TODO %?\n  %i\n  %a")
        ("n" "Note" entry (file "~/notes/org/inbox.org")
         "* %?\n  %i\n  %a")))

