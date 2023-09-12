(use-modules (gnu)
             (guix profiles))

(define guix-base-env
  %base-packages)

(define base-env
  (map specification->package
    (list "fish" "fish-foreign-env" "tmux" "neovim" "git" "openssh-sans-x"
      "mosh" "ncurses")))

(define fish-optional-dependencies-env
  (map specification->package
    (list "parallel" "tar" "botan" "libressl" "xz" "lz4")))

(define tmux-optional-dependencies-env
  (map specification->package
    (list)))

(define neovim-optional-dependencies-env
  (map specification->package
    (list
      "ripgrep" "fd"
      ;; "efm-langserver not available
      "python" "python-watchdog" "python-pynvim" "python-flake8"
      "shellcheck")))

(define guix-env
  (map specification->package
    (list "guix" "guile")))

(define encryption-env
  (map specification->package
    (list "libressl" "gnupg" "botan")))

(define compression-env
  (map specification->package
    (list "tar" "gzip" "zip" "unzip" "unrar-free" "p7zip" "bzip2" "xz" "lz4")))

(define cxx-env
  (map specification->package
    (list "gcc-toolchain" "clang-toolchain" "make" "ninja" "cmake" "boost")))

(define writing-env
  (map specification->package
    (list "tectonic" "pandoc"))) ; "asciidoctor" not available

(define python-env
  (map specification->package
    (list "python" "python-numpy" "python-scipy"))) ; "poetry" currently fails

(define julia-env
  (map specification->package
    (list "julia")))

(define desktop-env
  (map specification->package
    (list
      "xmonad" "xmessage" "ghc" "ghc-xmonad-contrib" "gcc-toolchain"
      "ungoogled-chromium"
      "openssh")))
