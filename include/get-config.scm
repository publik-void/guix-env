(use-modules
  (guix packages))

(include "package-set-definitions.scm")
(include "service-set-definitions.scm")

(define (get-config container? desktop? essential-only?)
  (home-environment
    (packages
      (filter
        (lambda (package) (let
            ((supported? (supported-package? (%current-system))))
          (begin
            (when (not supported?) (begin
              (display (string-append "Skipping package " (package-name package)
                " because it is not supported on " (%current-system) "."))
              (newline)))
            supported?)))
        (append
          (if container? guix-base-package-set '())
          (if container? ssh-package-set '())
          base-package-set
          fish-optional-dependencies-package-set
          tmux-optional-dependencies-package-set
          neovim-optional-dependencies-package-set
          encryption-package-set
          compression-package-set
          (if essential-only? '() cxx-package-set)
          (if essential-only? '() writing-package-set)
          (if essential-only? '() python-package-set)
          (if essential-only? '() julia-package-set)
          (if desktop? desktop-package-set '()))))
    (services
      (append
        service-set-common-resources
        (if desktop? service-set-common-resources-desktop '())
        service-set-ssh
        service-set-git
        service-set-fish
        service-set-tmux
        service-set-neovim
        (if desktop? service-set-xmonad '())))))
