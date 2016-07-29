defmodule Mailjet.Client do


	defmacro __using__(config) do
		quote do
		@conf unquote(config)
		def conf, do: @conf
			def send_email(email) do
				unquote(__MODULE__).send_email(conf(), email)
			end
		end
	end

	def send_email(conf, email) do
		do_send_email(conf, email)
	end

	def account_info() do
		conf = []
		ctype   = 'application/json'
		body = ""
		request( conf, :get , url("REST/myprofile",Application.get_env(:mailjet,:mailjet_endpoint)),[], ctype, body )
	end

	def event_openinformation do
		conf = []
		ctype   = 'application/json'
		body = ""
		request( conf, :get , url("REST/openinformation",Application.get_env(:mailjet,:mailjet_endpoint)),[], ctype, body )
	end
	
	defp do_send_email( conf, email) do
		attrs = Dict.merge(email, %{
				to: Dict.fetch!(email, :to),
				from: Dict.fetch!(email, :from),
				text: Dict.get(email, :text, ""),
				html: Dict.get(email, :html, ""),
				subject: Dict.get(email, :subject, ""),
				})
		ctype   = 'application/x-www-form-urlencoded'
		body    = URI.encode_query(attrs)
		request(conf, :post, url("send", Application.get_env(:mailjet,:mailjet_endpoint)), [], ctype, body)
	end

	def url(path, domain), do: Path.join([domain, path])

	def request(conf, method, url, headers, ctype, body) do
		url  = String.to_char_list(url)
		opts = conf[:httpc_opts] || []

		case method do
			:get ->
				headers = headers ++ [auth_header()]
				:httpc.request(:get, {url, headers}, opts, body_format: :binary)
			_httpvs->
				headers = headers ++ [auth_header(), {'Content-Type', ctype}]
				:httpc.request(method, {url, headers, ctype, body}, opts, body_format: :binary)
		end
		|> normalize_response
	end

	defp auth_header() do
		{'Authorization', 'Basic ' ++ String.to_char_list(Base.encode64("#{Application.get_env(:mailjet,:mailjet_key)}:#{Application.get_env(:mailjet,:mailjet_keyprivate)}" ))}
	end

	defp normalize_response(response) do
		case response do
			{:ok, {{_httpvs, 200, _status_phrase}, json_body}} ->
				{:ok, json_body}
			{:ok, {{_httpvs, 200, _status_phrase}, _headers, json_body}} ->
				{:ok, json_body}
			{:ok, {{_httpvs, status, _status_phrase}, json_body}} ->
				{:error, status, json_body}
			{:ok, {{_httpvs, status, _status_phrase}, _headers, json_body}} ->
				{:error, status, json_body}
			{:error, reason} -> {:error, :bad_fetch, reason}
		end
	end
end
