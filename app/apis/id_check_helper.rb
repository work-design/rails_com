module IdCheckHelper
  CODE = 'xx'
  extend self

  def do_verify(idcard, name)
    url = 'https://eid.shumaidata.com/eid/check'
    body = {
      idcard: idcard,
      name: name
    }
    headers = {
      Authorization: "APPCODE #{CODE}"
    }

    r = HTTPX.headers(headers).post(url, params: body)
    JSON.parse(r.to_s)
  end

end
