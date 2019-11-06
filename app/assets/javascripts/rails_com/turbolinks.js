document.querySelectorAll('input[data-filter="true"], select[data-filter="true"]').forEach(function(el) {
  el.addEventListener('change', function () {
    let url = new URL(location)
    url.searchParams.set(this.name, this.value)

    Turbolinks.visit(url)
  })
})
