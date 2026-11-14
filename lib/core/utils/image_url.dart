/// Makes a product image address loadable from this phone.
///
/// Catalog illustrations are served by the website (`/catalog-images/*`)
/// but stored as absolute URLs such as
/// `http://localhost:3000/catalog-images/tee.svg`. "localhost" on a phone is
/// the phone itself, so those are re-pointed at [webAppUrl] — the app's
/// version of the website's `imageSrc`. Other URLs are left as they are.
String? resolveImageUrl(String? url, {required String webAppUrl}) {
  if (url == null || url.isEmpty) return null;
  final base = webAppUrl.replaceAll(RegExp(r'/+$'), '');
  final uri = Uri.tryParse(url);
  if (uri == null) return null;
  if (!uri.hasScheme) return url.startsWith('/') ? '$base$url' : null;
  if (uri.path.startsWith('/catalog-images/')) return '$base${uri.path}';
  return url;
}
