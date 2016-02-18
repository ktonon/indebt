defmodule LandTransferTaxTest do
	use ExUnit.Case
	doctest Indebt

	import Indebt.LandTransferTax

	@ontario %{
		country: "CAD",
		province: "ON",
		other: "stuff",
		that_may: "change"
	}

	@toronto "Toronto"

	@type_com "commercial"

	@type_res "residential"

	# test "for no regions returns 0" do
	# 	# assert for_regions([]).(50_000) == 0
	# end

	test "cheap in Ontario" do
		assert calc(20_000, @ontario) == 100
	end

	test "pricey in Ontario" do
		assert calc(900_000, @ontario) == 11_975
	end

	test "pricey residential in Ontario" do
		region = Dict.put(@ontario, :type, @type_res)
		assert calc(900_000, region) == 14_475
	end

	test "pricey residential in Toronto" do
		region = Dict.put(@ontario, :city, @toronto)
		region = Dict.put(region, :type, @type_res)
		assert calc(900_000, region) == 28_200
	end

	test "config keys for Ontario" do
		region = Dict.put(@ontario, :type, @type_com)
		assert config_keys(region) == [:ontario_cad]
	end

	test "config keys for Ontario residential" do
		region = Dict.put(@ontario, :type, @type_res)
		assert config_keys(region) == [:res_ontario_cad]
	end

	test "config keys for Toronto" do
		region = Dict.put(@ontario, :city, @toronto)
		region = Dict.put(region, :type, @type_com)
		assert config_keys(region) == [:ontario_cad, :toronto_cad]
	end

	test "config keys for Toronto residential" do
		region = Dict.put(@ontario, :city, @toronto)
		region = Dict.put(region, :type, @type_res)
		assert config_keys(region) == [:res_ontario_cad, :toronto_cad]
	end
end