#define MAX_MINIGUN 200 //�������� ��������� ��������� (!!!����������� �� ����������!!!)
#define DISTANCE_ACTIVE 4.0 //���������� �� ������� ����� "�����" � �������
#define BULLET 1485 //������ ����

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
CreateMinigun - ������� ������� ( ����������, ��������� ���� �������� ������, ������ �������� 1...199); ���������� ID ��������
DestroyMinigun - ���������� ������� (ID ��������); ���������� 1 ��� ������� ������������ � 0 ��� ������
DestroyAllMinigun - ���������� ��� ��������
IsValidMinigun - ���������� 1 ���� ������� � ������������� ID ���������� � 0 ���� ���
GetPlayerInMinigun - ���������� ID ������ ������������ �� ��������� � ������������� ID, ���� �� ��������� ��� ������ ���������� INVALID_PLAYER_ID
*/
