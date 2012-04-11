-module(m_store).
-export([up/0, down/0, data/0]).

-include_lib("memento_core/include/records.hrl").


up() ->
    mnesia:create_schema([node()]),
    mnesia:start(),

    mnesia:create_table(m_user,
        [ {disc_copies, [node()] },
             {attributes,      
                record_info(fields, m_user)} ]),

    mnesia:create_table(m_agent,
        [ {disc_copies, [node()] },
             {attributes,      
                record_info(fields, m_agent)} ]),

    mnesia:create_table(m_object,
        [ {disc_copies, [node()] },
             {attributes,      
                record_info(fields, m_object)} ]),

    mnesia:create_table(m_trap,
        [ {disc_copies, [node()] },
             {attributes,      
                record_info(fields, m_trap)} ]),

    mnesia:create_table(m_manager,
        [ {disc_copies, [node()] },
             {attributes,      
                record_info(fields, m_manager)} ]),

    ok.


down() ->
    mnesia:delete_table(m_manager),
    mnesia:delete_table(m_trap),
    mnesia:delete_table(m_object),
    mnesia:delete_table(m_agent),
    mnesia:delete_table(m_user),
    ok.



%% @doc Load test data
data() ->
   F = fun() ->
        Ms =    [ #m_manager{id=1, node=node(), port=5001, address=[127,0,0,1]}
                , #m_manager{id=2, node=memento@delta, port=5001, address=[127,0,0,2]}],
        As =    [ #m_agent{id=1, port=4000, address=[127,0,0,1], version=v2c}
                , #m_agent{id=1, port=4000, address=[127,0,0,2], version=v2c}],
        [mnesia:write(X) || X <- Ms ++ As]
        end,
    mnesia:transaction(F).


manager_name(Id) ->
    %% Call mnesia:dirty_read(Tab, Key)
    [#m_manager{name=Name}] = mnesia:dirty_read(m_manager, Id),
    Name.

agent_name(Id) ->
    [#m_agent{name=Name}] = mnesia:dirty_read(m_agent, Id),
    Name.