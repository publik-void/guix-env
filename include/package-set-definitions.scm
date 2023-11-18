(use-modules
  (gnu)
  (gnu packages xorg)
  (guix profiles))

(include "../packages/st-patched/st-patched.scm")
  ;; NOTE: Including `%base-packages` in the home profile replaces the programs
  ;; under `/run/setuid-programs`, which e.g. makes `sudo` unuseable.
  ;; NOTE: Guix is not included in the `%base-packages`, but can be made
  ;; available in a container with --nested
(define guix-base-package-set
  %base-packages)

(define ssh-package-set
  (map specification->package
    (list "openssh-sans-x" "mosh")))

(define base-package-set
  (cons* console-setup (map specification->package
    (list "fish" "fish-foreign-env" "tmux" "neovim" "git" "ncurses"))))

(define fish-optional-dependencies-package-set
  (map specification->package
    (list "parallel" "tar" "botan" "libressl" "xz" "lz4")))

(define tmux-optional-dependencies-package-set
  (map specification->package
    (list)))

(define neovim-optional-dependencies-package-set
  (map specification->package
    (list
      "ripgrep" "fd"
      ;; TODO: "efm-langserver"/"go-efm-langserver" not available
      "python" "python-watchdog" "python-pynvim" "python-flake8"
      "shellcheck")))

(define encryption-package-set
  (map specification->package
    (list "libressl" "gnupg" "botan")))

(define compression-package-set
  (map specification->package
    (list "tar" "gzip" "zip" "unzip" "p7zip" "bzip2" "xz" "lz4")))

(define cxx-package-set
  (map specification->package
    (list "gcc-toolchain" "clang-toolchain" "make" "ninja" "cmake" "boost")))

(define writing-package-set
  (map specification->package
    (list "tectonic" "pandoc"))) ; "asciidoctor" not available
    ;; TODO: "ruby-asciidoctor" is available, but needs extra config

(define python-package-set
  (map specification->package
    (list "python" "python-numpy" "python-scipy"))) ; "poetry" currently fails

(define julia-package-set
  (map specification->package
    (list "julia")))

(define desktop-package-set
  (append
    (map specification->package
      (list
        "sx"
        "xrdb"
        "font-hack"
        "xmonad" "xmessage" "ghc" "ghc-xmonad-contrib" "gcc-toolchain"
        ;;"dmenu"
        "ungoogled-chromium"
        "openssh"))
    (list st-patched)))

