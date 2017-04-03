-- Show selected properties from computers (that typically aren't in SCOM)
SELECT
    computer.OrganizationalUnit as 'Active directory OU', 
    usr.DisplayName as Custodian, 
    assetStatus.DisplayName As Status, 	
    computer.Notes_5CFC0E2A_AB82_5830_D4BB_0596CBED1984 as Notes
FROM mtv_computer computer with (nolock)
    LEFT OUTER JOIN RelationshipView ownedBy with (nolock) on ownedBy.SourceEntityId = computer.BaseManagedEntityId
        and ownedBy.RelationshipTypeId='CBB45424-B0A2-72F0-D535-541941CDF8E1' --System.ConfigItemOwnedByUser
        and ownedBy.IsDeleted=0
    LEFT OUTER JOIN MTV_System$Domain$User usr with (nolock) on usr.BaseManagedEntityId = ownedBy.TargetEntityId
    LEFT OUTER JOIN fn_EnumerationsView('ENG','ENU') assetStatus on computer.AssetStatus_B6E7674B_684A_040D_30B8_D1B42CCB3BC6 = assetStatus.id
WHERE 
    computer.BaseManagedEntityId = '00000000-0000-0000-0000-000000000000'