package statemachine.flow.impl
{
import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;
import org.swiftsuspenders.Injector;

import statemachine.flow.api.Payload;
import statemachine.support.TestEvent;
import statemachine.support.TestRegistry;
import statemachine.support.cmds.CommandWithTestEvent;
import statemachine.support.cmds.MockCommandOne;
import statemachine.support.cmds.MockCommandThree;
import statemachine.support.cmds.MockCommandTwo;
import statemachine.support.guards.GrumpyGuard;
import statemachine.support.guards.HappyGuard;
import statemachine.support.guards.OnlyIfGoodbye;

public class ExecutorTest implements TestRegistry
{
    private var _injector:Injector;
    private var _classUnderTest:Executor;
    private var _executedCommands:Vector.<Class>;

    [Before]
    public function before():void
    {
        _executedCommands = new Vector.<Class>();
        _injector = new Injector();
        _classUnderTest = new Executor( _injector );
        _injector.map( TestRegistry ).toValue( this );
    }

    [Test]
    public function successful_execution_returns_true():void
    {
        const group:ExecutionData = new ExecutionData();
        group.pushCommand( MockCommandOne );

        assertThat( _classUnderTest.execute( group ), isTrue() );
    }

    [Test]
    public function unsuccessful_execution_returns_false():void
    {
        const group:ExecutionData = new ExecutionData();
        group.pushCommand( MockCommandOne );
        group.pushGuard( GrumpyGuard );

        assertThat( _classUnderTest.execute( group ), isFalse() );
    }

    [Test]
    public function multiple_execution_no_guards__all_commands_executed():void
    {
        const group:ExecutionData = new ExecutionData();
        group.pushCommand( MockCommandTwo );
        group.pushCommand( MockCommandThree );
        group.pushCommand( MockCommandOne );

        _classUnderTest.execute( group );

        assertThat( _executedCommands.length, equalTo( 3 ) );
        assertThat(
                _executedCommands,
                array(
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandOne )
                ) );
    }

    [Test]
    public function multiple_execution_multiple_grumpy_guards__no_commands_executed():void
    {
        const group:ExecutionData = new ExecutionData();
        group.pushCommand( MockCommandThree );
        group.pushCommand( MockCommandOne );
        group.pushCommand( MockCommandTwo );
        group.pushGuard( HappyGuard );
        group.pushGuard( GrumpyGuard );
        group.pushGuard( HappyGuard );

        _classUnderTest.execute( group );

        assertThat( _executedCommands.length, equalTo( 0 ) );
    }

    [Test]
    public function multiple_execution_multiple_happy_guards__all_commands_executed():void
    {
        const group:ExecutionData = new ExecutionData();
        group.pushCommand( MockCommandThree );
        group.pushCommand( MockCommandTwo );
        group.pushCommand( MockCommandOne );
        group.pushGuard( HappyGuard );
        group.pushGuard( HappyGuard );
        group.pushGuard( HappyGuard );

        _classUnderTest.execute( group );

        assertThat( _executedCommands.length, equalTo( 3 ) );
        assertThat(
                _executedCommands,
                array(
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandOne )
                ) );
    }

    [Test]
    public function test_payload_gets_injected():void
    {
        const payload:Payload = new Payload().add( new TestEvent( "Goodbye" ), TestEvent );
        const group:ExecutionData = new ExecutionData();
        group.payload = payload;
        group.pushCommand( CommandWithTestEvent );
        group.pushGuard( OnlyIfGoodbye );

        _classUnderTest.execute( group );


    }

    [Test]
    public function test_payload_is_removed_after_execution_approved():void
    {
        const payload:Payload = new Payload().add( new TestEvent( "Goodbye" ), TestEvent );
        const group:ExecutionData = new ExecutionData();
        group.payload = payload;
        group.pushCommand( CommandWithTestEvent );
        group.pushGuard( OnlyIfGoodbye );

        _classUnderTest.execute( group );

        assertThat( _injector.hasMapping( TestEvent ), isFalse() );

    }

    [Test]
    public function test_payload_is_removed_when_execution_declined():void
    {
        const payload:Payload = new Payload().add( new TestEvent( "Hello" ), TestEvent );
        const group:ExecutionData = new ExecutionData();
        group.payload = payload;
        group.pushCommand( CommandWithTestEvent );
        group.pushGuard( OnlyIfGoodbye );

        _classUnderTest.execute( group );

        assertThat( _injector.hasMapping( TestEvent ), isFalse() );

    }

    public function register( value:* ):void
    {
        _executedCommands.push( value );
    }
}
}
