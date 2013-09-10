package flow.impl
{
import flow.impl.support.ClassRegistry;
import flow.impl.support.ExecutableTrigger;
import flow.impl.support.cmds.MockCommandOne;
import flow.impl.support.cmds.MockCommandThree;
import flow.impl.support.cmds.MockCommandTwo;
import flow.impl.support.guards.GrumpyGuard;
import flow.impl.support.guards.HappyGuard;
import flow.impl.support.guards.JoyfulGuard;

import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.strictlyEqualTo;
import org.swiftsuspenders.Injector;

public class StressTest implements ClassRegistry
{
    private var _classUnderTest:TriggerMap;
    private var _injector:Injector;
    private var _commands:Vector.<Class>;
    private var _trigger:ExecutableTrigger;

    [Before]
    public function before():void
    {
        _commands = new Vector.<Class>();
        _injector = new Injector();
        _classUnderTest = new TriggerMap( _injector );
        _injector.map( ClassRegistry ).toValue( this );
        _injector.map( Injector ).toValue( _injector );
        _injector.map( Executor );
        _injector.map( ExecutableTrigger ).asSingleton();
        _trigger = _injector.getInstance( ExecutableTrigger );
    }


    [Test]
    public function test_always_blocks():void
    {
        _classUnderTest
                .map( _trigger )
                .always.executeAll( MockCommandThree, MockCommandTwo )
                .and.always.executeAll( MockCommandThree ).onApproval( GrumpyGuard, HappyGuard )
                .and.always.executeAll( MockCommandTwo, MockCommandOne ).onApproval( JoyfulGuard, HappyGuard );

        _trigger.execute();

        assertThat(
                _commands,
                array(
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandOne )
                )
        )
    }

    [Test]
    public function test_always_blocks_onApproval_first():void
    {
        _classUnderTest
                .map( _trigger )
                .always.executeAll( MockCommandThree, MockCommandTwo )
                .and.always.onApproval( GrumpyGuard, HappyGuard ).executeAll( MockCommandThree )
                .and.always.onApproval( JoyfulGuard, HappyGuard ).executeAll( MockCommandTwo, MockCommandOne );

        _trigger.execute();

        assertThat(
                _commands,
                array(
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandOne )
                )
        )
    }

    [Test]
    public function test_either_blocks_last_block_only_approved():void
    {
        _classUnderTest
                .map( _trigger )
                .either.executeAll( MockCommandThree, MockCommandTwo ).onApproval( GrumpyGuard, HappyGuard )
                .or.executeAll( MockCommandThree ).onApproval( JoyfulGuard, GrumpyGuard )
                .or.executeAll( MockCommandTwo, MockCommandOne, MockCommandTwo );

        _trigger.execute();

        assertThat(
                _commands,
                array(
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandOne ),
                        strictlyEqualTo( MockCommandTwo )
                )
        )
    }

    [Test]
    public function test_either_blocks__all_blocks_approved():void
    {
        _classUnderTest
                .map( _trigger )
                .either.executeAll( MockCommandThree, MockCommandTwo ).onApproval( HappyGuard )
                .or.executeAll( MockCommandThree ).onApproval( JoyfulGuard, HappyGuard )
                .or.executeAll( MockCommandTwo, MockCommandOne, MockCommandTwo );

        _trigger.execute();

        assertThat(
                _commands,
                array(
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo )
                )
        )
    }


    [Test]
    public function test_either_blocks_onApproval_first():void
    {
        _classUnderTest
                .map( _trigger )
                .either.onApproval( GrumpyGuard, HappyGuard ).executeAll( MockCommandThree, MockCommandTwo )
                .or.onApproval( JoyfulGuard, GrumpyGuard ).executeAll( MockCommandThree )
                .or.executeAll( MockCommandTwo, MockCommandOne, MockCommandTwo );

        _trigger.execute();

        assertThat(
                _commands,
                array(
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandOne ),
                        strictlyEqualTo( MockCommandTwo )
                )
        )
    }

    [Test]
    public function test_either_always_blocks_mixed():void
    {
        _classUnderTest
                .map( _trigger )
                .always.executeAll( MockCommandThree, MockCommandThree, MockCommandOne )
                .and.either.onApproval( GrumpyGuard, HappyGuard ).executeAll( MockCommandThree, MockCommandTwo )
                .or.onApproval( JoyfulGuard, GrumpyGuard ).executeAll( MockCommandThree )
                .and.always.onApproval( JoyfulGuard, HappyGuard ).executeAll( MockCommandTwo, MockCommandOne, MockCommandThree );

        _trigger.execute();

        assertThat(
                _commands,
                array(
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandOne ),

                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandOne ),
                        strictlyEqualTo( MockCommandThree )
                )
        )
    }

    [Test]
    public function test_either_always_blocks_mixed_all_approved():void
    {
        _classUnderTest
                .map( _trigger )
                .always.executeAll( MockCommandThree, MockCommandThree, MockCommandOne )
                .and.either.onApproval( HappyGuard ).executeAll( MockCommandThree, MockCommandTwo )
                .or.onApproval( JoyfulGuard ).executeAll( MockCommandThree )
                .and.always.onApproval( JoyfulGuard, HappyGuard ).executeAll( MockCommandTwo, MockCommandThree, MockCommandOne );

        _trigger.execute();

        assertThat(
                _commands,
                array(
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandOne ),

                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo ),

                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandOne )
                )
        )
    }

    [Test]
    public function test_either_always_blocks_mixed_none_approved():void
    {
        _classUnderTest
                .map( _trigger )
                .always.executeAll( MockCommandThree, MockCommandThree, MockCommandOne ).onApproval( JoyfulGuard, GrumpyGuard )
                .and.either.onApproval( GrumpyGuard, HappyGuard ).executeAll( MockCommandThree, MockCommandTwo )
                .or.onApproval( GrumpyGuard ).executeAll( MockCommandThree )
                .and.always.onApproval( JoyfulGuard, GrumpyGuard ).executeAll( MockCommandTwo, MockCommandThree, MockCommandOne );

        _trigger.execute();

        assertThat( _commands.length, equalTo( 0 ) );
    }


    public function register( c:Class ):void
    {
        _commands.push( c );
    }
}
}
