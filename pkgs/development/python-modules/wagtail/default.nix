{ anyascii
, beautifulsoup4
, buildPythonPackage
, callPackage
, django
, django-filter
, django-modelcluster
, django-taggit
, django_treebeard
, djangorestframework
, draftjs-exporter
, fetchpatch
, fetchPypi
, html5lib
, l18n
, lib
, openpyxl
, permissionedforms
, pillow
, requests
, telepath
, willow
}:

buildPythonPackage rec {
  pname = "wagtail";
  version = "4.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-s89gs3H//Dc3k6BLZUC4APyDgiWY9LetWAkI+kXQTf8=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-45809.patch";
      url = "https://github.com/wagtail/wagtail/commit/0bacd29473107d9d7f5b723a15a683449679756d.patch";
      sha256 = "sha256-f14ZvO3UYZDlUNYup9OeqSdArGBL7QZYNP0KB/sQgWc=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "beautifulsoup4>=4.8,<4.12" "beautifulsoup4>=4.8"
  '';

  propagatedBuildInputs = [
    django
    django-modelcluster
    django-taggit
    django_treebeard
    djangorestframework
    django-filter
    pillow
    beautifulsoup4
    html5lib
    willow
    requests
    openpyxl
    anyascii
    draftjs-exporter
    permissionedforms
    telepath
    l18n
  ];

  # Tests are in separate derivation because they require a package that depends
  # on wagtail (wagtail-factories)
  doCheck = false;

  passthru.tests.wagtail = callPackage ./tests.nix {};

  meta = with lib; {
    description = "A Django content management system focused on flexibility and user experience";
    homepage = "https://github.com/wagtail/wagtail";
    changelog = "https://github.com/wagtail/wagtail/blob/v${version}/CHANGELOG.txt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sephi ];
  };
}
