%define script_name collect_data

Name:           %{script_name}
Version:        1.0
Release:        1%{?dist}
Summary:        TUI System Utilization Monitor Script

License:        MIT
URL:            https://github.com/Sanoj-sudo/collect.git
Source0:        %{script_name}.sh

BuildArch:      noarch

%description
A terminal-based interactive system monitor script using gum and standard Linux utilities.

%prep

%build

%install
mkdir -p %{buildroot}/usr/local/bin
install -m 0755 %{SOURCE0} %{buildroot}/usr/local/bin/%{script_name}

%files
/usr/local/bin/%{script_name}

%changelog
* Fri Apr 04 2025 sanoj sanojkumar715@gmail.com - 1.0-1
- Initial RPM build
