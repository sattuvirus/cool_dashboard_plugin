prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.4.00.08'
,p_default_workspace_id=>1810418193191039
,p_default_application_id=>108
,p_default_owner=>'ADMIN'
);
end;
/
prompt --application/shared_components/plugins/region_type/cool_dashbard_plugins_satish
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(21815525424573424)
,p_plugin_type=>'REGION TYPE'
,p_name=>'COOL.DASHBARD.PLUGINS.SATISH'
,p_display_name=>'Cool Dashboard Plugin'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'FUNCTION SQL_TO_SYS_REFCURSOR (',
'    P_IN_SQL_STATEMENT   CLOB,',
'    P_IN_BINDS           SYS.DBMS_SQL.VARCHAR2_TABLE',
') RETURN SYS_REFCURSOR AS',
'    VR_CURS         BINARY_INTEGER;',
'    VR_REF_CURSOR   SYS_REFCURSOR;',
'    VR_EXEC         BINARY_INTEGER;',
'/* TODO make size dynamic */',
'    VR_BINDS        VARCHAR(100);',
'BEGIN',
'    VR_CURS         := DBMS_SQL.OPEN_CURSOR;',
'    DBMS_SQL.PARSE(',
'        VR_CURS,',
'        P_IN_SQL_STATEMENT,',
'        DBMS_SQL.NATIVE',
'    );',
'    IF P_IN_BINDS.COUNT > 0 THEN',
'        FOR I IN 1..P_IN_BINDS.COUNT LOOP',
'        /* TODO find out how to prevent ltrim */',
'            VR_BINDS   := LTRIM(',
'                P_IN_BINDS(I),',
'                '':''',
'            );',
'            DBMS_SQL.BIND_VARIABLE(',
'                VR_CURS,',
'                VR_BINDS,',
'                V(VR_BINDS)',
'            );',
'        END LOOP;',
'    END IF;',
'',
'    VR_EXEC         := DBMS_SQL.EXECUTE(VR_CURS);',
'    VR_REF_CURSOR   := DBMS_SQL.TO_REFCURSOR(VR_CURS);',
'    RETURN VR_REF_CURSOR;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        IF DBMS_SQL.IS_OPEN(VR_CURS) THEN',
'            DBMS_SQL.CLOSE_CURSOR(VR_CURS);',
'        END IF;',
'        RAISE;',
'END;',
'',
'FUNCTION F_AJAX (',
'    P_REGION   IN         APEX_PLUGIN.T_REGION,',
'    P_PLUGIN   IN         APEX_PLUGIN.T_PLUGIN',
') RETURN APEX_PLUGIN.T_REGION_AJAX_RESULT IS',
'    VR_RESULT       APEX_PLUGIN.T_REGION_AJAX_RESULT;',
'    VR_CUR          SYS_REFCURSOR;',
'    VR_BIND_NAMES   SYS.DBMS_SQL.VARCHAR2_TABLE;',
'BEGIN',
'/* undocumented function of APEX for get all bindings */',
'    VR_BIND_NAMES   := WWV_FLOW_UTILITIES.GET_BINDS(P_REGION.SOURCE);',
'',
'/* execute binding*/',
'    VR_CUR          := SQL_TO_SYS_REFCURSOR(',
'        RTRIM(',
'            P_REGION.SOURCE,',
'            '';''',
'        ),',
'        VR_BIND_NAMES',
'    );',
'',
'/* create json */',
'    APEX_JSON.OPEN_OBJECT;',
'    APEX_JSON.WRITE(',
'        ''row'',',
'        VR_CUR',
'    );',
'    APEX_JSON.CLOSE_OBJECT;',
'',
'    RETURN VR_RESULT;',
'END;',
'',
'FUNCTION F_RENDER (',
'    P_REGION                IN                      APEX_PLUGIN.T_REGION,',
'    P_PLUGIN                IN                      APEX_PLUGIN.T_PLUGIN,',
'    P_IS_PRINTER_FRIENDLY   IN                      BOOLEAN',
') RETURN APEX_PLUGIN.T_REGION_RENDER_RESULT IS',
'',
'    VR_RESULT         APEX_PLUGIN.T_REGION_RENDER_RESULT;',
'    VR_ITEMS2SUBMIT   APEX_APPLICATION_PAGE_REGIONS.AJAX_ITEMS_TO_SUBMIT%TYPE := APEX_PLUGIN_UTIL.PAGE_ITEM_NAMES_TO_JQUERY(P_REGION.AJAX_ITEMS_TO_SUBMIT);',
'BEGIN',
'    APEX_CSS.ADD_FILE(',
'        P_NAME        => ''dash_code'',',
'        P_DIRECTORY   => P_PLUGIN.FILE_PREFIX,',
'        P_VERSION     => NULL,',
'        P_KEY         => ''dashboard''',
'    );',
'    ',
'    APEX_JAVASCRIPT.ADD_LIBRARY(',
'        P_NAME        => ''dash_code'',',
'        P_DIRECTORY   => P_PLUGIN.FILE_PREFIX,',
'        P_VERSION     => NULL,',
'        P_CHECK_TO_ADD_MINIFIED => TRUE,',
'        P_KEY         => ''dashboard''',
'    );',
'',
'   HTP.P(''<div id="'' || APEX_ESCAPE.HTML_ATTRIBUTE( P_REGION.STATIC_ID ) || ''-p" class="mat-flip-cards"></div>'');',
'',
'    APEX_JAVASCRIPT.ADD_ONLOAD_CODE( ''Dashboard.render(''',
'     || APEX_JAVASCRIPT.ADD_VALUE( P_REGION.STATIC_ID, TRUE )    ',
'     || APEX_JAVASCRIPT.ADD_VALUE( APEX_PLUGIN.GET_AJAX_IDENTIFIER, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( P_REGION.NO_DATA_FOUND_MESSAGE, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( VR_ITEMS2SUBMIT, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( P_REGION.ESCAPE_OUTPUT, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( P_REGION.ATTRIBUTE_01, FALSE )',
'     || '');'' );',
'',
'    RETURN VR_RESULT;',
'END;'))
,p_api_version=>2
,p_render_function=>'F_RENDER'
,p_ajax_function=>'F_AJAX'
,p_standard_attributes=>'SOURCE_SQL:AJAX_ITEMS_TO_SUBMIT:NO_DATA_FOUND_MESSAGE:ESCAPE_OUTPUT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>'This is card type dashboard plugin where you can show your data into different cards view.'
,p_version_identifier=>'1.0.0'
,p_about_url=>'https://github.com/sattuvirus'
,p_files_version=>17
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(21816250566595681)
,p_plugin_id=>wwv_flow_api.id(21815525424573424)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'ConfiguraionJSON'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'{ "cardWidth": 2, "refresh": 0 ,"releaveHideIcon":"fa-long-arrow-down"}	'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(21815700343573450)
,p_plugin_id=>wwv_flow_api.id(21815525424573424)
,p_name=>'SOURCE_SQL'
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Select 1 as sort_order,',
'''All Data'' title,',
' ''1'' data1,',
'''fa fa-check-square-o '' as icon_class,',
'''db2_red'' as container_class,',
' ''Test ''as text',
'from Dual ',
' union all',
'Select 2 as sort_order,',
'''Confirmed'' title,',
' ''2'' data1,',
'  ''fa fa-comments''   as  icon_class',
'     , ''db2_blue''     as  container_class,',
'     ''TEST'' as text',
'from Dual ',
'    union all',
'   Select 3 as sort_order,',
'''Pending'' title,',
' ''3'' data1,',
'  ''fa fa-cubes''   as  icon_class',
'     , ''db2_green''     as  container_class,',
'     ''TEST'' as text',
'from Dual ',
' union all',
'   Select 4 as sort_order,',
'''Cancel'' title,',
' ''4'' data1,',
'  ''fa fa-tint''   as  icon_class',
'     , ''db2_orange''     as  container_class,',
'     ''TEST'' as text',
'from Dual ',
'order by 1'))
,p_depending_on_has_to_exist=>true
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E6462325F636F6E7461696E65727B6261636B67726F756E642D636F6C6F723A236564363634373B636F6C6F723A236666663B666C6F61743A6C6566743B6865696768743A31323070783B6D617267696E2D72696768743A31253B70616464696E673A35';
wwv_flow_api.g_varchar2_table(2) := '70783B706F736974696F6E3A72656C61746976653B77696474683A3234257D2E6462325F69636F6E5F636F6E7461696E65727B6865696768743A313030253B6C6566743A303B70616464696E672D746F703A333070783B706F736974696F6E3A6162736F';
wwv_flow_api.g_varchar2_table(3) := '6C7574653B746578742D616C69676E3A63656E7465723B746F703A303B77696474683A383070787D2E6462325F7265647B6261636B67726F756E642D636F6C6F723A236564363634377D2E6462325F626C75657B6261636B67726F756E642D636F6C6F72';
wwv_flow_api.g_varchar2_table(4) := '3A233236376462337D2E6462325F677265656E7B6261636B67726F756E642D636F6C6F723A233638633138327D2E6462325F6F72616E67657B6261636B67726F756E642D636F6C6F723A236661643535637D2E6462325F6D61696E7B626F726465722D6C';
wwv_flow_api.g_varchar2_table(5) := '6566743A31707820736F6C696420236666663B6C6566743A383070783B70616464696E673A3020313070783B706F736974696F6E3A6162736F6C7574653B746F703A3570783B6865696768743A31313070787D2E6462325F6E756D6265727B666F6E742D';
wwv_flow_api.g_varchar2_table(6) := '73697A653A312E38656D3B70616464696E673A313070782030203570787D2E6462325F636F6E7461696E657220697B666F6E742D73697A653A353070787D2E6462325F746578747B666F6E742D73697A653A2E38656D3B6C696E652D6865696768743A31';
wwv_flow_api.g_varchar2_table(7) := '2E31656D7D406D6564696120286D61782D77696474683A313230307078297B2E6462325F636F6E7461696E65727B6865696768743A31343070787D2E6462325F69636F6E5F636F6E7461696E65727B70616464696E672D746F703A343070787D2E646232';
wwv_flow_api.g_varchar2_table(8) := '5F6D61696E7B6865696768743A31333070787D7D406D6564696120286D61782D77696474683A313030307078297B2E6462325F636F6E7461696E65727B6865696768743A31303070783B77696474683A3438253B6D617267696E2D746F703A313070787D';
wwv_flow_api.g_varchar2_table(9) := '2E6462325F677265656E7B636C6561723A6C6566747D7D406D6564696120286D61782D77696474683A3630307078297B2E6462325F636F6E7461696E65727B636C6561723A6C6566743B6865696768743A31303070783B77696474683A3938257D2E6462';
wwv_flow_api.g_varchar2_table(10) := '325F6D61696E7B6865696768743A393070787D7D2E742D5265706F72742D7265706F72742074686561642074687B6261636B67726F756E642D636F6C6F723A233236376462333B636F6C6F723A236666667D2E742D5265706F72742D7265706F72742074';
wwv_flow_api.g_varchar2_table(11) := '6865616420746820617B636F6C6F723A236666667D612E636972636C652D74696C652D666F6F7465727B636F6C6F723A236666663B666F6E742D73697A653A756E7365747D2E6462325F636F6E7461696E65723A686F7665727B6261636B67726F756E64';
wwv_flow_api.g_varchar2_table(12) := '2D636F6C6F723A236363637D2E6462325F7472656E64795F70696E6B7B6261636B67726F756E642D636F6C6F723A233766356138337D2E6462325F74726F706963616C5F626C75657B6261636B67726F756E642D636F6C6F723A236264643465377D2E64';
wwv_flow_api.g_varchar2_table(13) := '62325F696E7465725F6F72616E67657B6261636B67726F756E642D636F6C6F723A236666346530307D2E6462325F617A616C65617B6261636B67726F756E642D636F6C6F723A236565633063367D2E6462325F6461726B5F7265647B6261636B67726F75';
wwv_flow_api.g_varchar2_table(14) := '6E642D636F6C6F723A236134303630367D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(21818983345622965)
,p_plugin_id=>wwv_flow_api.id(21815525424573424)
,p_file_name=>'dash_code.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7661722044617368626F6172643D66756E6374696F6E28297B2275736520737472696374223B76617220653D7B76657273696F6E3A22312E302E30222C6973415045583A66756E6374696F6E28297B72657475726E22756E646566696E656422213D7479';
wwv_flow_api.g_varchar2_table(2) := '70656F6620617065787D2C64656275673A7B696E666F3A66756E6374696F6E2872297B652E69734150455828292626617065782E64656275672E696E666F2872297D2C6572726F723A66756E6374696F6E2872297B652E69734150455828293F61706578';
wwv_flow_api.g_varchar2_table(3) := '2E64656275672E6572726F722872293A636F6E736F6C652E6572726F722872297D7D2C6C6F616465723A7B73746172743A66756E6374696F6E2872297B696628652E697341504558282929617065782E7574696C2E73686F775370696E6E657228242872';
wwv_flow_api.g_varchar2_table(4) := '29293B656C73657B76617220613D2428223C7370616E3E3C2F7370616E3E22293B612E6174747228226964222C226C6F61646572222B72292C612E616464436C617373282263742D6C6F6164657222293B766172206E3D2428223C693E3C2F693E22293B';
wwv_flow_api.g_varchar2_table(5) := '6E2E616464436C617373282266612066612D726566726573682066612D32782066612D616E696D2D7370696E22292C6E2E63737328226261636B67726F756E64222C2272676261283132312C3132312C3132312C302E362922292C6E2E6373732822626F';
wwv_flow_api.g_varchar2_table(6) := '726465722D726164697573222C223130302522292C6E2E637373282270616464696E67222C223135707822292C6E2E6373732822636F6C6F72222C22776869746522292C612E617070656E64286E292C242872292E617070656E642861297D7D2C73746F';
wwv_flow_api.g_varchar2_table(7) := '703A66756E6374696F6E2865297B2428652B22203E202E752D50726F63657373696E6722292E72656D6F766528292C2428652B22203E202E63742D6C6F6164657222292E72656D6F766528297D7D2C6A736F6E53617665457874656E643A66756E637469';
wwv_flow_api.g_varchar2_table(8) := '6F6E28652C72297B76617220613D7B7D3B69662822737472696E67223D3D747970656F662072297472797B723D4A534F4E2E70617273652872297D63617463682865297B636F6E736F6C652E6572726F7228224572726F72207768696C65207472792074';
wwv_flow_api.g_varchar2_table(9) := '6F20706172736520746172676574436F6E6669672E20506C6561736520636865636B20796F757220436F6E666967204A534F4E2E205374616E6461726420436F6E6669672077696C6C20626520757365642E22292C636F6E736F6C652E6572726F722865';
wwv_flow_api.g_varchar2_table(10) := '292C636F6E736F6C652E6572726F722872297D656C736520613D723B7472797B613D242E657874656E642821302C652C72297D63617463682872297B636F6E736F6C652E6572726F7228224572726F72207768696C652074727920746F206D6572676520';
wwv_flow_api.g_varchar2_table(11) := '32204A534F4E7320696E746F207374616E64617264204A534F4E20696620616E7920617474726962757465206973206D697373696E672E20506C6561736520636865636B20796F757220436F6E666967204A534F4E2E205374616E6461726420436F6E66';
wwv_flow_api.g_varchar2_table(12) := '69672077696C6C20626520757365642E22292C636F6E736F6C652E6572726F722872292C613D652C636F6E736F6C652E6572726F722861297D72657475726E20617D2C6E6F446174614D6573736167653A7B73686F773A66756E6374696F6E28652C7229';
wwv_flow_api.g_varchar2_table(13) := '7B76617220613D2428223C6469763E3C2F6469763E22292E63737328226D617267696E222C223132707822292E6373732822746578742D616C69676E222C2263656E74657222292E637373282270616464696E67222C2236347078203022292E61646443';
wwv_flow_api.g_varchar2_table(14) := '6C61737328226E6F64617461666F756E646D65737361676522292C6E3D2428223C6469763E3C2F6469763E22292C733D2428223C7370616E3E3C2F7370616E3E22292E616464436C6173732822666122292E616464436C617373282266612D7365617263';
wwv_flow_api.g_varchar2_table(15) := '6822292E616464436C617373282266612D327822292E6373732822686569676874222C223332707822292E63737328227769647468222C223332707822292E6373732822636F6C6F72222C222344304430443022292E63737328226D617267696E2D626F';
wwv_flow_api.g_varchar2_table(16) := '74746F6D222C223136707822293B6E2E617070656E642873293B76617220643D2428223C7370616E3E3C2F7370616E3E22292E746578742872292E6373732822646973706C6179222C22626C6F636B22292E6373732822636F6C6F72222C222337303730';
wwv_flow_api.g_varchar2_table(17) := '373022292E6373732822666F6E742D73697A65222C223132707822293B612E617070656E64286E292E617070656E642864292C242865292E617070656E642861297D2C686964653A66756E6374696F6E2865297B242865292E6368696C6472656E28222E';
wwv_flow_api.g_varchar2_table(18) := '6E6F64617461666F756E646D65737361676522292E72656D6F766528297D7D7D3B66756E6374696F6E20722865297B76617220723D2428223C6469763E3C2F6469763E22293B72657475726E20722E616464436C6173732822617065782D726F7722292C';
wwv_flow_api.g_varchar2_table(19) := '652E617070656E642872292C727D66756E6374696F6E206128652C612C6E2C73297B76617220643D242865293B642E706172656E7428292E63737328226F766572666C6F77222C22696E686572697422293B766172206F3D66756E6374696F6E2865297B';
wwv_flow_api.g_varchar2_table(20) := '76617220723D2428223C6469763E3C2F6469763E22293B72657475726E20722E616464436C61737328226A617661696E68616E6420617065782D636F6E7461696E657222292C652E617070656E642872292C727D2864292C693D72286F292C743D303B73';
wwv_flow_api.g_varchar2_table(21) := '2E72656C656176654869646549636F6E3B242E6561636828612C66756E6374696F6E28652C61297B742B3D732E6361726457696474683B766172206E3D2428223C6469763E3C2F6469763E22293B6E2E616464436C6173732822617065782D632D636F6C';
wwv_flow_api.g_varchar2_table(22) := '2D222B732E636172645769647468293B76617220643D2428223C6469763E3C2F6469763E22292C633D612E434F4E5441494E45525F434C4153533B642E616464436C61737328226462325F636F6E7461696E657222292E616464436C6173732863293B76';
wwv_flow_api.g_varchar2_table(23) := '617220703D2428223C6469763E3C2F6469763E22293B702E616464436C61737328226462325F6D61696E22293B766172206C3D2428223C6469763E3C2F6469763E22293B6C2E616464436C61737328226462325F6E756D62657222292C6C2E7465787428';
wwv_flow_api.g_varchar2_table(24) := '612E4441544131292C702E617070656E64286C292C642E617070656E642870293B76617220763D2428223C6469763E3C2F6469763E22293B762E616464436C61737328226462325F7469746C6522292C762E7465787428612E5449544C45292C702E6170';
wwv_flow_api.g_varchar2_table(25) := '70656E642876292C642E617070656E642870293B76617220663D2428223C6469763E3C2F6469763E22293B662E616464436C61737328226462325F7469746C6522292C662E7465787428612E54455854292C702E617070656E642866292C642E61707065';
wwv_flow_api.g_varchar2_table(26) := '6E642870293B76617220753D2428223C6469763E3C2F6469763E22293B752E616464436C61737328226462325F69636F6E5F636F6E7461696E657222293B76617220683D612E49434F4E5F434C4153532C673D2428223C693E3C2F693E22293B672E6164';
wwv_flow_api.g_varchar2_table(27) := '64436C6173732822666122292E616464436C6173732868292C752E617070656E642867292C642E617070656E642875292C6E2E617070656E642864292C692E617070656E64286E292C743E3D3132262628693D72286F292C743D30297D297D7265747572';
wwv_flow_api.g_varchar2_table(28) := '6E7B72656E6465723A66756E6374696F6E28722C6E2C732C642C6F2C69297B76617220743D2223222B722B222D70222C633D7B7D3B66756E6374696F6E207028297B76617220723D643B7472797B617065782E7365727665722E706C7567696E286E2C7B';
wwv_flow_api.g_varchar2_table(29) := '706167654974656D733A727D2C7B737563636573733A66756E6374696F6E2872297B2166756E6374696F6E28722C6E2C732C642C6F297B242872292E656D70747928292C6E2E726F7726266E2E726F772E6C656E6774683E303F6128722C6E2E726F772C';
wwv_flow_api.g_varchar2_table(30) := '302C6F293A28242872292E63737328226D696E2D686569676874222C2222292C652E6E6F446174614D6573736167652E73686F7728722C7329292C652E6C6F616465722E73746F702872297D28742C722C732C302C63297D2C6572726F723A66756E6374';
wwv_flow_api.g_varchar2_table(31) := '696F6E2865297B636F6E736F6C652E6572726F7228652E726573706F6E736554657874297D2C64617461547970653A226A736F6E227D297D63617463682865297B636F6E736F6C652E6572726F7228224572726F72207768696C652074727920746F2067';
wwv_flow_api.g_varchar2_table(32) := '657420446174612066726F6D204150455822292C636F6E736F6C652E6572726F722865297D7D633D652E6A736F6E53617665457874656E64287B6361726457696474683A342C726566726573683A307D2C69292C7028293B7472797B617065782E6A5175';
wwv_flow_api.g_varchar2_table(33) := '657279282223222B72292E62696E6428226170657872656672657368222C66756E6374696F6E28297B7028297D297D63617463682865297B636F6E736F6C652E6572726F7228224572726F72207768696C652074727920746F2062696E64204150455820';
wwv_flow_api.g_varchar2_table(34) := '72656672657368206576656E7422292C636F6E736F6C652E6572726F722865297D632E726566726573682626632E726566726573683E302626736574496E74657276616C2866756E6374696F6E28297B7028297D2C3165332A632E72656672657368297D';
wwv_flow_api.g_varchar2_table(35) := '7D7D28293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(21824014442903555)
,p_plugin_id=>wwv_flow_api.id(21815525424573424)
,p_file_name=>'dash_code.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
