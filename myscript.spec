Name:           collect-info
Version:        1.0
Release:        1%{?dist}
Summary:        System Information Collection Script with gum UI

License:        MIT
BuildArch:      noarch

%description
This package provides a system info script using gum for a terminal UI experience.

%prep

%build

%install
mkdir -p %{buildroot}/usr/local/bin
cp -a %{_sourcedir}/gum %{buildroot}/usr/local/bin/
cp -a %{_sourcedir}/collect_data.sh %{buildroot}/usr/local/bin/

%files
/usr/local/bin/gum
/usr/local/bin/collect_data.sh

%changelog
* Mon Apr 07 2025 Ysanoj sanojkumar715@gmail.com - 1.0-1
- Initial RPM release with embedded gum binary
