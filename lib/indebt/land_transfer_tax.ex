defmodule Indebt.LandTransferTax do
	
	def config(:res_ontario_cad), do: [
		brackets: [
		{0.005,  55_000}, # $ 55,000
		{0.010, 195_000}, # $250,000
		{0.015, 150_000}, # $400,000
		{0.020}
		]
	]
	
	def config(:ontario_cad), do: [
		brackets: [
		{0.005,  55_000}, # $ 55,000
		{0.010, 195_000}, # $250,000
		{0.015}
		]
	]

	def config(:toronto_cad), do: [
		brackets: [
		{0.005,  55_000}, # $ 55,000
		{0.010, 345_000}, # $400,000
		{0.020}
		]
	]

	def config_keys(%{
		country: "CAD",
		province: "ON",
		city: "Toronto",
		type: "residential"
		}), do: [:res_ontario_cad, :toronto_cad]

	def config_keys(%{
		country: "CAD",
		province: "ON",
		city: "Toronto"
		}), do: [:ontario_cad, :toronto_cad]

	def config_keys(%{
		country: "CAD",
		province: "ON",
		type: "residential"
		}), do: [:res_ontario_cad]

	def config_keys(%{
		country: "CAD",
		province: "ON"
		}), do: [:ontario_cad]

	# Calculate land transfer tax for the given region
	def calc(val, region) when is_map(region), do: _calc_keys(val, config_keys(region))

	# Process the list of configurations
	defp _calc_keys(_val, []), do: 0
	defp _calc_keys(val, [key | rest]), do: _calc_config(val, config(key)) + _calc_keys(val, rest)

	# Choose which calculator to use
	defp _calc_config(val, [brackets: brackets]), do: calc_brackets(val, brackets)


	defp calc_brackets(val, [{rate}]), do: val * rate
	defp calc_brackets(val, [{rate, limit} | _]) when val < limit do
		val * rate
	end
	defp calc_brackets(val, [{rate, limit} | rest]) do
		rate * limit + calc_brackets(val - limit, rest)
	end

end
