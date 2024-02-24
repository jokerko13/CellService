RegisterNetEvent('drz_cellservice:pridani', function(hodnota)
	TriggerClientEvent("esx_status:add", source, hodnota, DRZ.AmountAdd)
end)