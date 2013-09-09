package flow.impl
{
import flow.dsl.FlowGroupMapping;
import flow.impl.FlowError;
import flow.impl.support.ClassRegistry;
import flow.impl.support.PretendError;
import flow.impl.support.cmds.ErrorCommandOne;
import flow.impl.support.cmds.ErrorCommandTwo;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.strictlyEqualTo;
import org.swiftsuspenders.Injector;

public class ControlFlowErrorHandlingTest implements ClassRegistry
{
    private var _classUnderTest:ControlFlow;
    private var _injector:Injector;
    private var _executables:Vector.<Class>;
    private var _errorHandled:FlowError;

    [Before]
    public function before():void
    {
        _executables = new Vector.<Class>();
        _injector = new Injector();

        _classUnderTest = new ControlFlow( _injector );
        _injector.map( Injector ).toValue( _injector );
        _injector.map( Executor );
        _injector.map( FlowGroupMapping ).toValue( _classUnderTest );
        _injector.map( ClassRegistry ).toValue( this );


    }

    [After]
    public function after():void
    {
        _executables = null;
        _classUnderTest = null;
        _injector.teardown();
        _injector = null;

    }


    [Test]
    public function handle_as_function_catches_errors():void
    {

        _classUnderTest
                .always.executeAll( ErrorCommandOne )
                .and.handle( handleError );
        _classUnderTest.execute();

        assertThat( _errorHandled, instanceOf( FlowError ) );
    }

    [Test]
    public function sourceError_correct():void
    {

        _classUnderTest
                .always.executeAll( ErrorCommandOne )
                .and.handle( handleError );
        _classUnderTest.execute();
        assertThat( _errorHandled.sourceError, instanceOf( PretendError ) );

    }

    [Test]
    public function error_metrics_correct_for_ErrorCommandOne():void
    {
        _classUnderTest
                .always.executeAll( ErrorCommandOne )
                .and.handle( handleError );
        _classUnderTest.execute();
        assertThat( _errorHandled.origin, equalTo("flow.impl.support.cmds::ErrorCommandOne"))
        assertThat( _errorHandled.method, equalTo("execute()")) ;
        assertThat( _errorHandled.lineNumber, equalTo(10));

    }

    [Test]
    public function error_metrics_correct_for_ErrorCommandTwo():void
    {
        _classUnderTest
                .always.executeAll( ErrorCommandTwo )
                .and.handle( handleError );
        _classUnderTest.execute();
        assertThat( _errorHandled.origin, equalTo("flow.impl.support.cmds::ErrorCommandTwo"))
        assertThat( _errorHandled.method, equalTo("execute()")) ;
        assertThat( _errorHandled.lineNumber, equalTo(11));
    }


    public function handleError( error:Error ):void
    {
        _errorHandled = error as FlowError;
    }


    public function register( c:Class ):void
    {
        _executables.push( c );
    }
}
}
