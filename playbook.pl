#!/usr/bin/env perl

# TODO:
#   0. replace this script for a proper cli
#   1. gpg --export-ssh-key brenoleonhardt@gmail.com > ~/.ssh/blp.pub && chmod 0600 ~/.ssh/blp.pub
#   2. add user crontab
#       0 */4 * * *  $HOME/bin/cron/sync-books
#       */10 * * * * $HOME/bin/cron/sync-duckdns
#   3. files in etc should have a placeholder for USER and replace
#   4. why does udev rule runs twice? see journalctl -n 100 -t keyboard
#   5. add ./makepkg/aur/
#        cursor-bin
#        ngrok
#        obs-backgroundremoval
#        stremio
#        zoom

# Playbook =============================================================== {{{
configure(
    user  => $ENV{'USER'},
    host  => $ENV{'HOST'} // 'localhost',
    root  => 'root',
    debug => $ENV{'DEBUG'},
);

pacman(
    'arandr',                 'base',
    'base-devel',             'bash-completion',
    'bat',                    'bear',
    'blueman',                'bluez',
    'bluez-utils',            'bottom',
    'chromium',               'clang',
    'cmake',                  'conky',
    'cronie',                 'ctags',
    'docker',                 'dosfstools',
    'dunst',                  'dzen2',
    'fd',                     'feh',
    'file-roller',            'firefox',
    'fzf',                    'git',
    'gnome-backgrounds',      'go',
    'gopls',                  'gparted',
    'gpick',                  'gtk2',
    'gtk3',                   'gtk4',
    'gvim',                   'helm',
    'htop',                   'imagemagick',
    'inotify-tools',          'jq',
    'k9s',                    'lf',
    'lightdm',                'lightdm-gtk-greeter',
    'lldb',                   'lsof',
    'lua',                    'lua51',
    'lua52',                  'lua53',
    'luajit',                 'lua-language-server',
    'luarocks',               'man-db',
    'moreutils',              'musl',
    'ncdu',                   'net-tools',
    'network-manager-applet', 'ninja',
    'noto-fonts-emoji',       'otf-comicshanns-nerd',
    'ttf-indic-otf',          'noto-fonts-cjk',
    'pamixer',                'parted',
    'pass',                   'pass-otp',
    'pasystray',              'pavucontrol',
    'pdftk',                  'perl',
    'perl-tidy',              'python',
    'python-pipx',            'redshift',
    'renameutils',            'ripgrep',
    'rsync',                  'rustup',
    'screengrab',             'shellcheck',
    'shfmt',                  'sqlitebrowser',
    'stow',                   'stylua',
    'sxiv',                   'tmux',
    'tree',                   'ttf-3270-nerd',
    'ttf-firacode-nerd',      'udiskie',
    'unrar',                  'unzip',
    'usbutils',               'v4l2loopback-dkms',
    'wget',                   'wmctrl',
    'xarchiver',              'xclip',
    'xdotool',                'xorg-server-xephyr',
    'xorg-xev',               'xorg-xkill',
    'xorg-xlsclients',        'xorg-xmodmap',
    'xorg-xsetroot',          'xorg-xwininfo',
    'zathura',                'zathura-pdf-mupdf',
    'zip',                    'zk',
    'cpanminus',              'perl-local-lib',
    'man-pages',

    # new packages
    'isync', 'neomutt', 'notmuch', 'msmtp'
);

dirs(
    # default directories
    '~/git', '~/sketch', '~/tmp',

    # prevent stow folding
    '~/.config',
    '~/.config/systemd/user',
    '~/.gnupg',
    '~/.ssh',
    '~/.perl5'
);

stow(
    cwd     => '~/.dotfiles',
    target  => '~/',
    package => 'home',
);

etc(
    { file => 'lightdm-gtk-greeter.conf', dir => '/etc/lightdm/' },
    { file => '10-keyboard.rules',        dir => '/etc/udev/rules.d/' },
    { file => '40-wacom.rules',           dir => '/etc/udev/rules.d/' },
    { file => '10-keyboard.conf',         dir => '/etc/X11/xorg.conf.d/' },
    { file => '20-monitor.conf',          dir => '/etc/X11/xorg.conf.d/' },
    { file => '30-touchpad.conf',         dir => '/etc/X11/xorg.conf.d/' },
    { file => 'ssh_known_hosts',          dir => '/etc/ssh/' },
    { file => 'pacman.conf',              dir => '/etc/' },
);

git(
    [ 'git@github.com:brenopacheco/.dotfiles.git',       '~/.dotfiles' ],
    [ 'git@github.com:brenopacheco/.password-store.git', '~/.password-store' ],
    [ 'git@github.com:brenopacheco/notes.git',           '~/notes' ],
    [ 'git@github.com:brenopacheco/dwm-fork.git',        '~/git/dwm-fork' ],
    [ 'git@github.com:brenopacheco/st-fork.git',         '~/git/st-fork' ],
    [ 'git@github.com:brenopacheco/dmenu-fork.git',      '~/git/dmenu-fork' ],
    [ 'git@github.com:brenopacheco/slstatus-fork.git', '~/git/slstatus-fork' ],
);

systemctl(
    user => ['gpg-agent.target'],
    root => [
        'bluetooth.service',
        'cronie.service',

        'docker.service',
        'lightdm.service',

        # 'sshd.service'
    ]
);

makepkg(
    'makepkg/fork/dmenu',
    'makepkg/fork/dwm',
    'makepkg/fork/slstatus',
    'makepkg/fork/st',

    'makepkg/misc/neovim',
    'makepkg/misc/awscliv2',

    'makepkg/aur/asdf',
    'makepkg/aur/bun',
    'makepkg/aur/lls-addons',
    'makepkg/aur/rose-pine-gtk-theme-full',
    'makepkg/aur/slack-desktop',
    'makepkg/aur/xcursor-breeze',
);

asdf(
    {
        plugin   => "nodejs",
        url      => "https://github.com/asdf-vm/asdf-nodejs.git",
        versions => [ "23.3.0", "20.19.0" ],
        global   => "20.19.0"
    },
    {
        plugin   => "yarn",
        url      => "https://github.com/twuni/asdf-yarn.git",
        versions => ["1.20.0"],
        global   => "1.20.0"
    }
);

node(
    [ 'bash-language-server',          'bash-language-server' ],
    [ 'eslint',                        'eslint' ],
    [ 'prettier',                      'prettier' ],
    [ 'prettierd',                     '@fsouza/prettierd' ],
    [ 'eslint_d',                      'eslint_d' ],
    [ 'biome',                         '@biomejs/biome' ],
    [ 'tsc',                           'typescript' ],
    [ 'tsserver',                      'typescript-language-server' ],
    [ 'vim-language-server',           'vim-language-server' ],
    [ 'yaml-language-server',          'yaml-language-server' ],
    [ 'vscode-eslint-language-server', 'vscode-langservers-extracted' ],
    [ 'docker-langserver',             'dockerfile-language-server-nodejs' ],
    [ 'http-server',                   'http-server' ]
);

go(
    [ 'efm-langserver', 'github.com/mattn/efm-langserver@latest' ],
    [ 'godoc',          'golang.org/x/tools/cmd/godoc@latest' ],
    [ 'kind',           'sigs.k8s.io/kind@v0.20.0' ],
    [ 'lazydocker',     'github.com/jesseduffield/lazydocker@latest' ],
    [ 'yq',             'github.com/mikefarah/yq/v4@latest' ]
);

rust(
    {
        toolchains => [
            "stable-x86_64-unknown-linux-gnu",
            "nightly-x86_64-unknown-linux-gnu"
        ],
        default    => "stable-x86_64-unknown-linux-gnu",
        components => [
            "rust-analyzer-x86_64-unknown-linux-gnu",
            "rust-std-x86_64-unknown-linux-musl"
        ]
    }
);

gpg();

# }}} ------------------------------------------------------------------------
# Library ================================================================ {{{
use diagnostics;
use feature 'say';

my %cfg = ();

sub _cmd {
    my ($cmd) = @_;
    if ( $cfg{debug} ) {
        say "[DEBUG]: $cmd";
    }
    open my $fh, '-|', "$cmd 2>&1" or die "[ERROR] $cmd: $!\n";
    while ( my $line = <$fh> ) {
        print "  | $line";
    }
    close $fh or die "[ERROR] $cmd: $!\n";
    my $exit_status = $? >> 8;
    if ( $exit_status != 0 ) {
        print STDERR "\n[ERROR] command failed: $cmd\n";
        exit 1;
    }
}

sub _task {
    my ( $who, $cmd ) = @_;
    die "_copy must be used with 'root' or 'user'" if $who !~ /^(user)|(root)$/;
    $cmd =~ s/'/'\\''/g;
    $cmd = "ssh -A $cfg{$who}\@$cfg{host} '$cmd'";
    _cmd($cmd);
}

sub _copy {
    my ( $who, $src, $dst ) = @_;
    die "_copy must be used with 'root' or 'user'" if $who !~ /^(user)|(root)$/;
    $cmd = "scp -p -r $src $cfg{$who}\@$cfg{host}:$dst";
    _cmd($cmd);
}

sub _check {
    my ($cmd) = @_;
    $cmd =~ s/'/'\\''/g;
    $cmd = "ssh $cfg{user}\@$cfg{host} '$cmd'";
    if ( $cfg{debug} ) {
        say "[DEBUG]: $cmd";
    }
    my $out = `$cmd 2>&1`;
    if ( $out =~ /ssh: Could not resolve hostname/ ) {
        die "Error: $out";
    }
    return { ok => $? == 0, out => $out };
}

sub _unquote {
    my ($in) = @_;
    $in =~ s/['"]//g;
    return $in;
}

sub _test {
    my ($who) = @_;
    my $cmd = "ssh -o BatchMode=yes $cfg{$who}\@$cfg{host} 'exit'";
    if ( $cfg{debug} ) {
        say "[DEBUG]: $cmd";
    }
    my $out = `$cmd  2>&1`;
    if ( system("$cmd >/dev/null 2>&1") ) {
        my @message = (
            "Error: Unable to ssh into $who\@$cfg{host}.",
            "- Check the host is reacheable (HOST: systemctl is-active sshd)",
            "- Check the ssh-agent has the ssh key loaded (CLIENT: ssh-add -L)",
"- Check the host's ~/.ssh/authorized_keys for $who includes the key"
        );
        die join( "\n", @message );
    }

}

sub configure {
    my (%settings) = @_;
    $cfg{user}  = $settings{user};
    $cfg{root}  = $settings{root};
    $cfg{host}  = $settings{host};
    $cfg{debug} = $settings{debug};
    _test('root');
    _test('user');
}

sub git {
    my @in   = @_;
    my $dirs = join( " ", map { ${$_}[1] } @in );
    my $out  = _check("file -E $dirs")->{out};
    my @res  = $out =~ /^(.*):\s+ERROR: cannot stat/mg;
    if ( !@res ) {
        return say "[OK] git";
    }
    say "[-] git";
    my $mlen = ( sort { $b <=> $a } map { length( ${$_}[0] ) } @in )[0];
    for my $dir (@res) {
        my ($entry) = grep { $dir eq ${$_}[1] =~ s/~/\/home\/$cfg{user}/r } @in;
        my ( $repo, $dir ) = @{$entry};
        printf "  * cloning: %-${mlen}s -> %s\n", $repo, $dir;
        _task( 'user', "git clone $repo $dir" );
    }
}

sub stow {
    my (%cfg) = @_;
    my $args  = "--adopt -v 2 -d $cfg{cwd} -t $cfg{target} $cfg{package}";
    my @links = _check("stow -n $args")->{out} =~ /^LINK/mg;
    if ( !@links ) {
        return say "[OK] stow";
    }
    say "[-] stow";
    say "  * stowing: $cfg{cwd}/$cfg{package} => $cfg{target}";
    _task( 'user', "stow $args 2>&1 | grep 'LINK'" );
}

sub asdf {
    my @tasks = ();
    for my $conf (@_) {
        my $check     = _check("asdf list $conf->{plugin}");
        my $installed = $check->{ok};
        my %versions =
          map { $_ => 1 } $installed ? $check->{out} =~ /([^*\s]+)/mg : ();
        my @missing = grep { !exists $versions{$_} } @{ $conf->{versions} };
        my $current = $1 if $check->{out} =~ /\*(\S+)/;
        if ( !$installed ) {
            push @tasks, sub {
                say "  * installing: $conf->{plugin} => $conf->{url}";
                _task( 'user', "asdf plugin add $conf->{plugin} $conf->{url}" );
            };
        }
        for my $version (@missing) {
            push @tasks, sub {
                say "  * installing: $conf->{plugin} => $version";
                _task( 'user', "asdf install $conf->{plugin} $version" );
            };
        }
        if ( !$current || $current ne $conf->{global} ) {
            push @tasks, sub {
                say "  * set-global: $conf->{plugin} => $conf->{global}";
                _task( 'user', "asdf set -u $conf->{plugin} $conf->{global}" );
            };
        }
    }
    if ( !@tasks ) {
        return say "[OK] asdf";
    }
    say "[-] asdf";
    $_->() for @tasks;
}

sub pacman {
    my $res = _check("pacman -Q @_");
    if ( $res->{ok} ) {
        return say "[OK] pacman";
    }
    my @packages = $res->{out} =~ /^error: package '(.*)' was not found/mg;
    if ( !@packages ) {
        return say "[OK] pacman";
    }
    say "[-] pacman";
    say "  * installing: ", join( ', ', @packages );
    _task( 'root', "pacman -S --noconfirm --needed @packages" );
}

sub dirs {
    my $dirs = join( " ", @_ );
    my $out  = _check("file -E $dirs")->{out};
    my @res  = $out =~ /^(.*):\s+ERROR: cannot stat/mg;
    if ( !@res ) {
        return say "[OK] dirs";
    }
    say "[-] dirs";
    for my $dir (@res) {
        say "  * mkdir: $dir";
        _task( 'user', "mkdir -p $dir" );
    }
}

sub systemctl {
    my (%cfg) = @_;
    my @tasks = ();

    sub _service_status {
        my ( $services, $user_flag ) = @_;
        return () unless @$services;
        my $cmd_prefix = $user_flag ? "systemctl --user" : "systemctl";
        my @enabled =
          split( "\n", _check("$cmd_prefix is-enabled @$services")->{out} );
        my @active =
          split( "\n", _check("$cmd_prefix is-active @$services")->{out} );
        return map {
            $services->[$_] => {
                who     => $user_flag ? 'user' : 'root',
                enabled => $enabled[$_],
                active  => $active[$_]
            }
        } 0 .. $#$services;
    }
    my %root_status = _service_status( $cfg{root}, 0 );
    my %user_status = _service_status( $cfg{user}, 1 );
    my %status      = ( %root_status, %user_status );
    while ( my ( $service, $status ) = each %status ) {
        die "Unit not found: $service" if $status->{enabled} =~ /not-found/;
        my $cmd_prefix =
          $status->{who} eq 'user' ? "systemctl --user" : "systemctl";
        push @tasks, sub {
            say "  * enable [$status->{who}]: $service";
            _task( $status->{who}, "$cmd_prefix enable $service" );
            _task( $status->{who}, "$cmd_prefix start $service" );
          }
          if $status->{enabled} =~ /disabled/;
        push @tasks, sub {
            say "  * start  [$status->{who}]: $service";
            _task( $status->{who}, "$cmd_prefix start $service" );
          }
          if $status->{active} =~ /inactive/;
    }
    if ( !@tasks ) {
        return say "[OK] systemctl";
    }
    say "[-] systemctl";
    $_->() for @tasks;
}

sub etc {
    my @in     = @_;
    my $cmd    = "sha256sum " . join( " ", map { "$_->{dir}$_->{file}" } @in );
    my @checks = split( "\n", _check($cmd)->{out} );
    my @tasks  = ();
    for ( 0 .. $#checks ) {
        my ( $file, $dir ) = @{ $in[$_] }{ 'file', 'dir' };
        $dir = "$dir/" if $dir !~ /\/$/;
        my $src     = "./etc/$file";
        my $dst     = "$dir$file";
        my $dst_sha = $1 if $checks[$_]        =~ /^(\w+):?/;
        my $src_sha = $1 if `sha256sum ${src}` =~ /^(\w+):?/;
        if ( !defined($src_sha) ) {
            die "File not found ${src}";
        }
        if ( $src_sha ne $dst_sha ) {
            push @tasks, sub {
                say "  * copying: $src -> $dst";
                _copy( 'root', $src, $dst );
            }
        }
    }
    if ( !@tasks ) {
        return say "[OK] etc";
    }
    say "[-] etc";
    $_->() for @tasks;
}

# HACK: when having issues, `rm $dbfile && repo-add $dbfile && pacman -Sy`
sub makepkg {
    my $dbfile = "/usr/share/pacman/custom/custom.db.tar.zst";
    chomp( my $dbdir = `dirname $dbfile` );

    my @tasks = ();

    if ( !_check("test -f $dbfile")->{ok} ) {
        push @tasks, sub {
            say "  * initalizing $dbfile";
            _task( 'root', "mkdir -p $dbdir" );
            _task( 'root', "test -f $dbfile || repo-add $dbfile" );
            _task( 'root', "pacman -Sy" );
        }
    }

    sub _prepare {
        my @dirs = @_;
        my @pkgs = map { $& if /[^\/]+$/ } @dirs;
        my %info = map {
            my $dir      = $dirs[$_];
            my $pkg      = $pkgs[$_];
            my $PKGBUILD = "$dir/PKGBUILD";
            die "Not found: $PKGBUILD" if !-e $PKGBUILD;
            my $pkgver = $1 if `grep -m1 "pkgver=" $PKGBUILD` =~ /pkgver=(\S+)/;
            my $pkgrel = $1 if `grep -m1 "pkgrel=" $PKGBUILD` =~ /pkgrel=(\S+)/;
            my $name = $1 if `grep -m1 "pkgname=" $PKGBUILD` =~ /pkgname=(\S+)/;
            my $version = _unquote($pkgver) . "-" . _unquote($pkgrel);
            _unquote($name) => {
                dir     => $dir,
                version => $version,
                install => 1,
                build   => 1
            };
        } 0 .. $#pkgs;
        my @pkgnames = keys %info;
        my @installs = split( "\n", _check("pacman -Q @pkgnames 2>&1")->{out} );
        for (@installs) {
            next if /^error: package '(.*)' was not found/;
            my ( $pkgname, $installed ) = ( $1, $2 ) if /([\w-]+)\s(.+)/;
            next if ( !defined $pkgname ) or ( !defined $installed );
            die "Unknown error" if !exists( $info{$pkgname} );
            $info{$pkgname}{installed} = $installed;
            $info{$pkgname}{install} =
              `vercmp $info{$pkgname}{version} $installed`;
        }
        my @present = split( "\n", _check("pacman -Sl")->{out} );
        for (@present) {
            next if !/^custom /;
            my ( $pkgname, $version ) = ( $1, $2 )
              if $_ =~ /^custom (\S+?) (\S+)(\s\S+)?/;
            next if !exists( $info{$pkgname} );
            $info{$pkgname}{present} = $version;
            $info{$pkgname}{build} = `vercmp $info{$pkgname}{version} $version`;
        }
        return %info;
    }

    my %info = _prepare(@_);
    my @want =
      grep { $info{$_}{install} > 0 || $info{$_}{build} > 0 } keys %info;

    for (@want) {
        my $pkgname = $_;
        push @tasks, sub {
            my $props = $info{$pkgname};
            if ( $props->{build} > 0 ) {
                say "  * building package: $pkgname $props->{version}";
                my $tmpdir = _check("mktemp -d")->{out};
                chomp($tmpdir);
                _copy( 'user', $props->{dir}, "$tmpdir/$pkgname" );
                _task( 'user', "makepkg -scCf --dir $tmpdir/$pkgname" );
                _task( 'root',
                    "cp $tmpdir/$pkgname/$pkgname-*.pkg.tar.zst $dbdir/" );
                _task( 'root',
                    "repo-add --new $dbfile $dbdir/$pkgname-*.pkg.tar.zst" );
                _task( 'root', "pacman -Sy" );
            }
            if ( $props->{install} > 0 ) {
                say "  * installing package: $pkgname $props->{version}";
                _task( 'root', "pacman -Sy --noconfirm $pkgname" );
            }
        }
    }

    if ( !@tasks ) {
        return say "[OK] makepkg";
    }
    say "[-] makepkg";
    $_->() for @tasks;
}

sub node {
    my @pkgs  = map { ${$_}[0] } @_;
    my $check = _check('asdf list nodejs');
    die "asdf nodejs plugin not found" if !$check->{ok};
    my @versions = $check->{out}       =~ /([^*\s]+)/mg;
    my $current  = $1 if $check->{out} =~ /\*(\S+)/;
    my @tasks    = ();
    for my $version (@versions) {
        my $check   = _check("ls ~/.asdf/installs/nodejs/$version/bin/");
        my %bins    = map  { $_ => 1 } split( " ", $check->{out} );
        my @missing = grep { !exists $bins{ $_->[0] } } @_;
        for my $ref (@missing) {
            push @tasks, sub {
                say "  * installing [$version]: $ref->[0]";
                my $cmd = 'export PATH=$PATH:~/.asdf/shims; cd /tmp';
                $cmd .= " && asdf set nodejs $version";
                $cmd .= " && npm install -g $ref->[1]";
                _task( 'user', $cmd );
            }
        }
    }
    if ( !@tasks ) {
        return say "[OK] node";
    }
    say "[-] node";
    $_->() for @tasks;
    say "  * asdf reshim";
    _task( 'user', 'asdf reshim' );
}

sub go {
    my @pkgs    = map { ${$_}[0] } @_;
    my $check   = _check( 'PATH=$PATH;~/.go/bin ' . "which @pkgs" );
    my %missing = map  { $_ => 1 } $check->{out} =~ /^which: no (\S+) in/mg;
    my @want    = grep { exists $missing{ $_->[0] } } @_;
    if ( !@want ) {
        return say "[OK] go";
    }
    say "[-] go";
    for my $ref (@want) {
        say "  * installing: $ref->[0]";
        _task( 'user', "GOPATH=\$HOME/.go go install $ref->[1]" );
    }
}

sub rust {
    my ($conf) = @_;
    my @tasks = ();

    my $rustup_check = _check("which rustup");
    die "rustup not installed" if !$rustup_check->{ok};

    my $toolchain_check      = _check("rustup toolchain list");
    my @installed_toolchains = $toolchain_check->{out} =~ /^([^\s]+)/mg;
    for my $toolchain ( @{ $conf->{toolchains} } ) {
        if ( !grep { $_ eq $toolchain } @installed_toolchains ) {
            push @tasks, sub {
                say "  * installing toolchain: $toolchain";
                _task( 'user', "rustup toolchain install $toolchain" );
            };
        }
    }

    my $default_check     = _check("rustup default");
    my $default_toolchain = $1 if $default_check->{out} =~ /^([^\s]+)/;
    if ( $default_toolchain ne $conf->{default} ) {
        push @tasks, sub {
            say "  * setting default toolchain: $conf->{default}";
            _task( 'user', "rustup default $conf->{default}" );
        };
    }

    for my $toolchain ( @{ $conf->{toolchains} } ) {
        my $components_check =
          _check("rustup component list --installed --toolchain $toolchain");
        my %installed_components =
          map { $_ => 1 } split( /\n/, $components_check->{out} );
        for my $component ( @{ $conf->{components} } ) {
            if ( !exists $installed_components{$component} ) {
                push @tasks, sub {
                    say "  * installing component [$toolchain]: $component";
                    _task( 'user',
                        "rustup component add $component --toolchain $toolchain"
                    );
                };
            }
        }
    }

    if ( !@tasks ) {
        return say "[OK] rust";
    }
    say "[-] rust";
    $_->() for @tasks;
}

sub gpg {
    my @tasks = ();
    my ($fingerprint) =
      `gpgconf --list-options gpg` =~ /^default-key:.*:"(\w+)$/m
      or die "gpg has no default-key configured";
    my ($keygrip) =
      `gpg --with-keygrip -k $fingerprint` =~
      /^sub .*\[A\]\n\s*Keygrip = (\w+)/m
      or die "keygrip not found for subkey of type [A] ($fingerprint)";

    if ( !_check("gpg -k $fingerprint")->{ok} ) {
        my $srckey  = "/tmp/$fingerprint.key";
        my $dstkey  = "/home/$cfg{user}/$fingerprint.key";
        my $host    = "$cfg{user}\@$cfg{host}";
        my @message = (
            "Error: gpg key must be manually transfered. Run the following:\n",
            "gpg --export-secret-key --armor $fingerprint > $srckey &&",
            "  scp $srckey $host:$dstkey &&",
            "  rm $srckey &&",
            "  ssh -t $host 'gpg --import $dstkey' &&",
            "  ssh $host 'rm $dstkey'\n\n"
        );
        die join( "\n", @message );
    }
}

# }}} ------------------------------------------------------------------------
# vim:ft=perl:tw=80
