#define MAX_MINIGUN 200 //максимум возможных миниганов (!!!увеличивать не рекомендую!!!)
#define DISTANCE_ACTIVE 4.0 //расстояние на котором можно "войти" в миниган
#define BULLET 1485 //модель пули

stock CreateMinigun(Float:x, Float:y, Float:z, Float:rz, Float:radius)
	return CallRemoteFunction("src_CreateMinigun","fffff", x, y, z, rz, radius);
	
stock DestroyMinigun(id)
	return CallRemoteFunction("src_DestroyMinigun","d", id);
	
stock DestroyAllMinigun()
	return CallRemoteFunction("src_DestroyAllMinigun");
	
stock IsValidMinigun(id)
	return CallRemoteFunction("src_IsValidMinigun","d", id);
	
stock GetPlayerInMinigun(id)
	return CallRemoteFunction("src_GetPlayerInMinigun","d", id);
	
	
/*
CreateMinigun - создать миниган ( координаты, начальный угол поворота ствола, радиус действия 1...199); возвращает ID минигана
DestroyMinigun - уничтожить миниган (ID минигана); возвращает 1 при удачном уничтождении и 0 при ошибке
DestroyAllMinigun - уничтожить все миниганы
IsValidMinigun - возвращает 1 если миниган с запрашиваемым ID существует и 0 если нет
GetPlayerInMinigun - возвращает ID игрока находящегося за миниганом с запрашиваемым ID, если за миниганом нет игрока возвращает INVALID_PLAYER_ID
*/
