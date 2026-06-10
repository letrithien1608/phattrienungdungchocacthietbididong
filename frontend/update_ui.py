import os

files = [
    'lib/screens/bag_page.dart',
    'lib/screens/catalog_page.dart',
    'lib/screens/favorites_page.dart',
    'lib/screens/main_page.dart',
    'lib/screens/product_detail_page.dart',
    'lib/screens/rating_reviews_page.dart',
    'lib/screens/success_page.dart',
    'lib/screens/checkout_page.dart'
]

def replace_calls(content):
    content = content.replace('appState.toggleFavorite(p);', 'try { await appState.toggleFavorite(p); } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); return; }')
    content = content.replace('appState.toggleFavorite(product);', 'try { await appState.toggleFavorite(product); } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); return; }')
    content = content.replace('appState.addToCart(product, selectedSize!);', 'try { await appState.addToCart(product, selectedSize!); } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); return; }')
    content = content.replace("appState.addToCart(p, 'L');", "try { await appState.addToCart(p, 'L'); } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); return; }")
    content = content.replace('appState.increaseQuantity(item);', 'try { await appState.increaseQuantity(item); } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); return; }')
    content = content.replace('appState.decreaseQuantity(item);', 'try { await appState.decreaseQuantity(item); } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); return; }')
    content = content.replace('appState.removeFromCart(item);', 'try { await appState.removeFromCart(item); } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); return; }')
    content = content.replace('appState.addReview(widget.productId, review);', 'try { await appState.addReview(widget.productId, review); } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); return; }')
    content = content.replace('appState.checkout();', 'try { await appState.checkout(); } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); return; }')
    content = content.replace('onTap: () {', 'onTap: () async {')
    content = content.replace('onPressed: () {', 'onPressed: () async {')
    content = content.replace('onPressed: () =>', 'onPressed: () async =>')
    return content

for file in files:
    path = os.path.join('C:\\\\Users\\\\ASUS\\\\Documents\\\\JavaString\\\\flutter_auth_app', file.replace('/', '\\\\'))
    if os.path.exists(path):
        with open(path, 'r', encoding='utf-8') as f:
            c = f.read()
        c = replace_calls(c)
        with open(path, 'w', encoding='utf-8') as f:
            f.write(c)
        print(f'Updated {file}')
print('Done')
