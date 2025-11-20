Name: script
Version: 1.0
Release: 1
Summary: Script to count files in etc directory

License: MIT
BuildArch: noarch

Source0: script.sh

%description
Bash script that counts files in etc directory

%install
install -D -m 0755 %{SOURCE0} %{buildroot}/usr/bin/script.sh

%files
/usr/bin/script.sh

%changelog
* Thu Nov 20 2025 Maksym Lavryshchev <againnotrealemail@example.com> - 1.0-1
- First version
