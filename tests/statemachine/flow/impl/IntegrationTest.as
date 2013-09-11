package statemachine.flow.impl
{
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.strictlyEqualTo;
import org.swiftsuspenders.Injector;

import statemachine.flow.api.EventControlFlowMap;
import statemachine.flow.impl.support.ClassRegistry;
import statemachine.flow.impl.support.TestEvent;
import statemachine.flow.impl.support.cmds.MockCommandOne;
import statemachine.flow.impl.support.cmds.MockCommandThree;
import statemachine.flow.impl.support.cmds.MockCommandTwo;
import statemachine.flow.impl.support.guards.OnlyIfGoodbye;
import statemachine.flow.impl.support.guards.OnlyIfHello;

public class IntegrationTest implements ClassRegistry
{
    private var _classUnderTest:EventControlFlowMap;
    private var _injector:Injector;
    private var _commands:Vector.<Class>;
    private var _dispatcher:IEventDispatcher;


    [Before]
    public function before():void
    {
        _commands = new Vector.<Class>();
        _injector = new Injector();
        _dispatcher = new EventDispatcher();
        _classUnderTest = new EventMap( _injector );
        _injector.map( ClassRegistry ).toValue( this );
        _injector.map( IEventDispatcher ).toValue( _dispatcher );
        _injector.map( Injector ).toValue( _injector );
        _injector.map( Executor );
    }


    [Test]
    public function test_always_blocks__fire_identically_under_identical_guards():void
    {
        configureAlwaysBlock();
        sayHello();
        sayHello();

        assertThat(
                _commands,
                array(
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandThree ),

                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandThree )
                )
        )
    }


    [Test]
    public function test_always_blocks__fire_differently_under_changing_guards():void
    {
        configureAlwaysBlock();

        sayHello();
        sayGoodbye();

        assertThat(
                _commands,
                array(
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandThree ),

                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandOne )
                )
        )
    }


    [Test]
    public function test_always_blocks__onApproval_last():void
    {
        configureAlwaysBlockApprovalLast();

        sayHello();

        assertThat(
                _commands,
                array(
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandThree )
                )
        )
    }



    [Test]
    public function test_either_blocks__fire_identically_under_identical_guards():void
    {
        configureEitherBlock();

        sayHello();
        sayHello();

        assertThat(
                _commands,
                array(
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo ),

                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo )
                )
        )
    }


    [Test]
    public function test_either_blocks__fire_differently_under_changing_guards():void
    {
        configureEitherBlock();

        sayHello();
        sayGoodbye();

        assertThat(
                _commands,
                array(
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo ),

                        strictlyEqualTo( MockCommandThree )
                )
        )
    }

    [Test]
    public function test_either_blocks__onApproval_last():void
    {
        configureEitherBlockApprovalLast();
        sayHello();

        assertThat(
                _commands,
                array(
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo )
                )
        )
    }



    [Test]
    public function test_either_blocks__fallback_block_executed():void
    {
        configureEitherBlock();

        sayNothing();

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
    public function test_mixed_blocks__fire_identically_under_identical_guards():void
    {
        configureMixedBlocks();

        sayHello();
        sayHello();

        assertThat(
                _commands,
                array(
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandThree ),

                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandThree )
                )
        )
    }


    [Test]
    public function test_mixed_blocks__fire_differently_under_changing_guards():void
    {
        configureMixedBlocks()

        sayHello();
        sayGoodbye();

        assertThat(
                _commands,
                array(
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandThree ),

                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandOne )
                )
        )
    }


    public function register( c:Class ):void
    {
        _commands.push( c );
    }

    private function sayHello():void
    {
        _dispatcher.dispatchEvent( new TestEvent( "hello" ) );
    }

    private function sayGoodbye():void
    {
        _dispatcher.dispatchEvent( new TestEvent( "goodbye" ) );
    }

    private function sayNothing():void
    {
        _dispatcher.dispatchEvent( new TestEvent( "nothing" ) );
    }


    private function configureAlwaysBlock():void
    {
        _classUnderTest
                .on( TestEvent.TESTING, TestEvent )
                .always.executeAll( MockCommandThree, MockCommandTwo )
                .and.always.onApproval( OnlyIfHello ).executeAll( MockCommandThree )
                .and.always.onApproval( OnlyIfGoodbye ).executeAll( MockCommandTwo, MockCommandOne )
                .and.fix();


    }

    private function configureEitherBlock():void
    {
        _classUnderTest
                .on( TestEvent.TESTING, TestEvent )
                .either.onApproval( OnlyIfHello ).executeAll( MockCommandThree, MockCommandTwo )
                .or.onApproval( OnlyIfGoodbye ).executeAll( MockCommandThree )
                .or.executeAll( MockCommandTwo, MockCommandOne, MockCommandTwo )
                .and.fix();
    }

    private function configureMixedBlocks():void
    {
        _classUnderTest
                .on( TestEvent.TESTING, TestEvent )
                .always.executeAll( MockCommandThree, MockCommandTwo )
                .and.either.executeAll( MockCommandTwo, MockCommandThree ).onApproval( OnlyIfHello )
                .or.executeAll( MockCommandThree ).onApproval( OnlyIfGoodbye )
                .or.executeAll( MockCommandTwo, MockCommandOne, MockCommandTwo )
                .and.always.onApproval( OnlyIfGoodbye ).executeAll( MockCommandTwo, MockCommandOne )
                .and.fix();
    }

    private function configureAlwaysBlockApprovalLast():void
    {
        _classUnderTest
                .on( TestEvent.TESTING, TestEvent )
                .always.executeAll( MockCommandThree, MockCommandTwo )
                .and.always.executeAll( MockCommandThree ).onApproval( OnlyIfHello )
                .and.always.executeAll( MockCommandTwo, MockCommandOne ).onApproval( OnlyIfGoodbye )
                .and.fix();
    }

    private function configureEitherBlockApprovalLast():void
    {
        _classUnderTest
                .on( TestEvent.TESTING, TestEvent )
                .either.executeAll( MockCommandThree, MockCommandTwo ).onApproval( OnlyIfHello )
                .or.executeAll( MockCommandThree ).onApproval( OnlyIfGoodbye )
                .or.executeAll( MockCommandTwo, MockCommandOne, MockCommandTwo )
                .and.fix();
    }
}
}
