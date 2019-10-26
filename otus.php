<?php
session_start();

if (!$_SESSION['key']) {
	$_SESSION['key'] = random_int(100, 999);
	http_response_code(404);
?>
<script>
function setCookie(name, value, options = {}) {

  options = {
    path: '/',
    // при необходимости добавьте другие значения по умолчанию
    ...options
  };

  if (options.expires && options.expires.toUTCString) {
    options.expires = options.expires.toUTCString();
  }

  let updatedCookie = encodeURIComponent(name) + "=" + encodeURIComponent(value);

  for (let optionKey in options) {
    updatedCookie += "; " + optionKey;
    let optionValue = options[optionKey];
    if (optionValue !== true) {
      updatedCookie += "=" + optionValue;
    }
  }

  document.cookie = updatedCookie;
}

// Пример использования:
setCookie('key', '<?php echo $_SESSION['key']; ?>', {'max-age': 3600});
window.location.reload();
</script>
<?php
} else {
	if ($_SESSION['key']==$_COOKIE['key']) {
		echo file_get_contents("/opt/otus.txt");
	} else {
		echo "error";
		unset($_SESSION['key']);
		unset($_COOKIE['key']);
		http_response_code(404);
		die();
	}
}

