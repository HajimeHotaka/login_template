// register_font_licenses.dart
import 'package:flutter/foundation.dart';

void registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield const LicenseEntryWithLineBreaks(['fonts/NotoSans'], '''
Noto Sans

Copyright 2017 Google LLC.
All Rights Reserved.

Licensed under the SIL Open Font License, Version 1.1.

http://scripts.sil.org/OFL
''');

    yield const LicenseEntryWithLineBreaks(['fonts/NotoSansJP'], '''
Noto Sans JP

Copyright 2017 Google LLC.
All Rights Reserved.

Licensed under the SIL Open Font License, Version 1.1.

http://scripts.sil.org/OFL
''');

    yield const LicenseEntryWithLineBreaks(['fonts/NotoSansSC'], '''
Noto Sans SC

Copyright 2017 Google LLC.
All Rights Reserved.

Licensed under the SIL Open Font License, Version 1.1.

http://scripts.sil.org/OFL
''');

    yield const LicenseEntryWithLineBreaks(['fonts/NotoSansKR'], '''
Noto Sans KR

Copyright 2017 Google LLC.
All Rights Reserved.

Licensed under the SIL Open Font License, Version 1.1.

http://scripts.sil.org/OFL
''');
  });
}
