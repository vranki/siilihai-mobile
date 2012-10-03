Name: siilihai-mobile
Version: 0.9.3
Release: 1
Summary: Siilihai web forum reader mobile version
License: GPL
Group: Productivity/Networking/Web/Utilities
Url: http://siilihai.com/
Source: %{name}-%{version}.tar.gz
Requires: qt-components meegotouch-applauncherd
BuildRequires: qt-devel
BuildRequires: qt-mobility-devel


%description
Siilihai web forum reader mobile version

%prep
%setup -q

%build
%qmake config+=with_lib
make %{?jobs:-j%jobs}

%install
%{__rm} -rf %{buildroot}
%make_install

%files
%defattr(-,root,root,-)
/opt/%{name}/bin/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/scalable/apps/%{name}.svg
