(setq user-full-name "Brian Chen"
      user-mail-address "ihasdapi@gmail.com")

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq c-set-style "k&r")
(setq c-basic-offset 4)

(setq doom-font (font-spec :family "PragmataPro Liga" :size 15 :weight 'Medium)
      doom-variable-pitch-font (font-spec :family "Noto Sans" :size 14)
      doom-big-font (font-spec :family "PragmataPro Liga" :size 50))

(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

(setq doom-theme 'doom-one)

(setq org-hide-emphasis-markers t) ;; hide /.../ *...*, etc
(add-hook 'org-mode-hook 'variable-pitch-mode) ;; use variable pitch font for org files
(add-hook 'org-mode-hook 'org-bullets-mode)
(setq org-agenda-files (directory-files-recursively "~/org/" "\\.org$")) ;; use all files in ~org for agenda

;; Use fancy fonts in org
(custom-theme-set-faces
        'user
        '(org-block ((t (:inherit fixed-pitch))))
        '(org-code ((t (:inherit (shadow fixed-pitch)))))
        '(org-document-info ((t (:foreground "dark orange"))))
        '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
        '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
        '(org-link ((t (:foreground "royal blue" :underline t))))
        '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
        '(org-property-value ((t (:inherit fixed-pitch))) t)
        '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
        '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
        '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
        '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))

(setq org-directory "~/org/")
(setq org-image-actual-width nil) ;; make it so images aren't huge

;; use org autolist on org files
(add-hook 'org-mode-hook (lambda () (org-autolist-mode)))





(use-package! tree-sitter
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(after! company
        (setq company-idle-delay 0.4
        company-minimum-prefix-length 1
        company-dabbrev-downcase 0
        company-lsp-cache-candidates 'auto)
)

(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

;; Stop yanking/delete/etc from clobbering the system clipboard
(setq select-enable-clipboard nil)

;; define some bindings for system clipboard
(defun copy-to-clipboard()
  "Copies selection to x-clipboard."
  (interactive)
  (if (display-graphic-p)
      (progn
        (message "Yanked region to x-clipboard.")
        (call-interactively 'clipboard-kill-ring-save)
        )
    (if (region-active-p)
        (progn
          (shell-command-on-region (region-beginning) (region-end) "xsel -i -b")
          (message "Yanked region to clipboard.")
          (deactivate-mark))
      (message "No region active; can't yank to clipboard"))))

(defun paste-from-clipboard ()
  "Pastes from x-clipboard"
  (interactive)
  (if (display-graphic-p)
      (progn
        (clipboard-yank)
        (message "Pasted from system clipboard.")
        )
    (insert (shell-command-to-string "xsel -o - b"))))

(map! :leader
      :desc "copy-to-clipboard"
      "0 y" #'copy-to-clipboard)

(map! :leader
      :desc "paste-from-clipboard"
      "0 p" #'paste-from-clipboard)
