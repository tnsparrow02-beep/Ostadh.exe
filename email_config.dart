/// EmailJS settings (free plan, https://www.emailjs.com). Fill these 3 values, then rebuild.
/// They are PUBLIC identifiers (no secret): see the setup steps in README.md.
/// While they are empty, account creation works WITHOUT email verification.
const String kEmailJsServiceId = ''; // e.g. service_abc123
const String kEmailJsTemplateId = ''; // e.g. template_xyz789
const String kEmailJsPublicKey = ''; // e.g. AbCdEfGhIjKlMnOp

bool get kEmailVerificationEnabled =>
    kEmailJsServiceId.isNotEmpty && kEmailJsTemplateId.isNotEmpty && kEmailJsPublicKey.isNotEmpty;
